<?php

namespace App\Http\Controllers\Api;

use App\Events\EventCreated;
use App\Models\Event;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class EventController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Event::with(['club', 'category', 'users', 'backgroundImages'])->get();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request->validate([
            'club_id' => 'required|exists:clubs,id',
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
            'location' => 'required|string|max:255',
            'max_participants' => 'required|integer|min:1',
            'registered_participants' => 'nullable|integer',
            'content' => 'required|string',
            'status' => 'sometimes|string|in:active,cancelled,completed',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif'
        ]);

        $eventData = $request->except('image');
        if (!isset($eventData['status'])) {
            $eventData['status'] = 'active';
        }

        $event = Event::create($eventData);

        // Handle single image upload if present
        if ($request->hasFile('image')) {
            $backgroundImage = new \App\Models\BackgroundImage();
            $backgroundImage->event_id = $event->id;
            $backgroundImage->uploadImage($request->file('image'));
        }

        // Dispatch event
        event(new EventCreated($event));

        return response()->json($event->load(['club', 'category', 'backgroundImages']), 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Event $event)
    {
        return response()->json($event->load(['club', 'category', 'users', 'backgroundImages']));
    }

    /**
     * Display all events of a specific club.
     *
     * @param  int  $club_id
     * @return \Illuminate\Http\Response
     */
    public function showClbEvent($club_id)
    {
        // Lấy tất cả các sự kiện của club dựa vào club_id
        $events = Event::where('club_id', $club_id)->get();

        // Kiểm tra nếu không có sự kiện nào
        if ($events->isEmpty()) {
            return response()->json([
                'message' => 'No events found for this club.',
            ], 404);
        }

        // Trả về danh sách sự kiện
        return response()->json($events->load(['club', 'backgroundImages']));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Event $event)
    {
        // Get all request data except files
        $data = $request->all();

        // Remove file fields from data array
        unset($data['image']);

        // Validate basic data
        $validatedData = validator($data, [
            'club_id' => 'sometimes|exists:clubs,id',
            'category_id' => 'sometimes|exists:categories,id',
            'name' => 'sometimes|string|max:255',
            'start_date' => 'sometimes|date',
            'end_date' => 'sometimes|date|after_or_equal:start_date',
            'location' => 'sometimes|string|max:255',
            'max_participants' => 'sometimes|integer|min:1',
            'registered_participants' => 'sometimes|integer',
            'content' => 'sometimes|string',
            'status' => 'sometimes|string|in:active,cancelled,completed'
        ])->validate();

        // Update basic event data
        $event->update($validatedData);

        // Handle single image upload
        if ($request->hasFile('image')) {
            // Delete existing image if exists
            $existingImage = $event->backgroundImages()->first();
            if ($existingImage) {
                $existingImage->deleteImage();
                $existingImage->delete();
            }

            // Upload new image
            $backgroundImage = new \App\Models\BackgroundImage();
            $backgroundImage->event_id = $event->id;
            $backgroundImage->uploadImage($request->file('image'));
        }

        return response()->json($event->load(['club', 'category', 'backgroundImages']));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Event $event)
    {
        $event->delete();
        return response()->json(null, 204);
    }

    /**
     * Search for events based on one or more attributes.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function search(Request $request)
    {
        $query = Event::query();

        // Tìm kiếm theo tên sự kiện (tìm kiếm mờ)
        if ($request->has('name')) {
            $query->where('name', 'like', '%' . $request->name . '%');
        }

        // Tìm kiếm theo ID của câu lạc bộ
        if ($request->has('club_id')) {
            $query->where('club_id', $request->club_id);
        }

        // Tìm kiếm theo ID của danh mục
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Tìm kiếm theo thời gian bắt đầu (từ ngày)
        if ($request->has('start_date_from')) {
            $query->where('start_date', '>=', $request->start_date_from);
        }

        // Tìm kiếm theo thời gian bắt đầu (đến ngày)
        if ($request->has('start_date_to')) {
            $query->where('start_date', '<=', $request->start_date_to);
        }

        // Tìm kiếm theo thời gian kết thúc (từ ngày)
        if ($request->has('end_date_from')) {
            $query->where('end_date', '>=', $request->end_date_from);
        }

        // Tìm kiếm theo thời gian kết thúc (đến ngày)
        if ($request->has('end_date_to')) {
            $query->where('end_date', '<=', $request->end_date_to);
        }

        // Tìm kiếm theo vị trí (tìm kiếm mờ)
        if ($request->has('location')) {
            $query->where('location', 'like', '%' . $request->location . '%');
        }

        // Tìm kiếm theo trạng thái
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Tìm kiếm theo số người tham gia tối đa
        if ($request->has('max_participants')) {
            $query->where('max_participants', '=', $request->max_participants);
        }

        // Tìm kiếm sự kiện có số người tham gia tối đa lớn hơn
        if ($request->has('min_participants')) {
            $query->where('max_participants', '>=', $request->min_participants);
        }

        // Tìm kiếm theo nội dung (tìm kiếm mờ)
        if ($request->has('content')) {
            $query->where('content', 'like', '%' . $request->content . '%');
        }

        // Sắp xếp kết quả
        if ($request->has('sort_by')) {
            $sortDirection = $request->has('sort_direction') ? $request->sort_direction : 'asc';
            $query->orderBy($request->sort_by, $sortDirection);
        } else {
            // Mặc định sắp xếp theo ngày bắt đầu
            $query->orderBy('start_date', 'asc');
        }

        // Trả về kết quả với phân trang nếu cần
        $perPage = $request->has('per_page') ? $request->per_page : 10;
        
        if ($request->has('paginate') && $request->paginate === 'false') {
            $events = $query->get();
            return response()->json($events->load(['club', 'category', 'backgroundImages']));
        } else {
            $events = $query->paginate($perPage);
            return response()->json($events->load(['club', 'category', 'backgroundImages']));
        }
    }
}
