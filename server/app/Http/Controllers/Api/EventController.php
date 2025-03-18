<?php

namespace App\Http\Controllers\Api;

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
        return Event::with(['club', 'category', 'backgroundImages'])->get();
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
            'location' => 'nullable|string|max:255',
            'max_participants' => 'nullable|integer',
            'registered_participants' => 'nullable|integer',
            'content' => 'nullable|string',
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
        return response()->json($event->load([
            'club.backgroundImages' => function ($query) {
                $query->where('is_logo', 1);
            },
            'category',
            'backgroundImages'
        ]));
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
            'location' => 'nullable|string|max:255',
            'max_participants' => 'nullable|integer',
            'registered_participants' => 'nullable|integer',
            'content' => 'nullable|string',
            'status' => 'sometimes|string|in:active,inactive',
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
}
