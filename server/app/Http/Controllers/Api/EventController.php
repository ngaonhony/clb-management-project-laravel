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
        ]);
        $eventData = $request->all();
        if (!isset($eventData['status'])) {
            $eventData['status'] = 'active';
        }
        $event = Event::create($eventData);

        return response()->json($event, 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Event $event)
    {
        return response()->json($event->load(['club', 'category', 'backgroundImages']));
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
        $request->validate([
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
        ]);

        $event->update($request->all());
        return response()->json($event);
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
