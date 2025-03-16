<?php

namespace App\Http\Controllers\Api;

use App\Models\UserEvent;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class UserEventController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return UserEvent::with(['user', 'event'])->get();
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
            'user_id' => 'required|exists:users,id',
            'event_id' => 'required|exists:events,id',
        ]);

        $userEvent = UserEvent::create($request->all());
        return response()->json($userEvent, 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $user_id
     * @return \Illuminate\Http\Response
     */
    public function show($user_id)
    {
        $userEvents = UserEvent::where('user_id', $user_id)
            ->with(['event.club', 'event.club.category', 'event.backgroundImages'])
            ->get();

        return response()->json($userEvents);
    }


    /**
     * Get users by event ID.
     *
     * @param  int  $event_id
     * @return \Illuminate\Http\Response
     */
    public function getUsersByEvent($event_id)
    {
        $users = UserEvent::where('event_id', $event_id)
            ->with(['user.backgroundImages'])
            ->get()
            ->pluck('user');

        return response()->json($users);
    }


    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, UserEvent $userEvent)
    {
        $request->validate([
            'user_id' => 'sometimes|exists:users,id',
            'event_id' => 'sometimes|exists:events,id',
        ]);

        $userEvent->update($request->all());
        return response()->json($userEvent);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(UserEvent $userEvent)
    {
        $userEvent->delete();
        return response()->json(null, 204);
    }
}
