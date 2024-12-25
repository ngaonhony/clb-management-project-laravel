<?php

namespace App\Http\Controllers\Api;
use App\Models\Invitation;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class InvitationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Invitation::with('club')->get();
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
            'email' => 'required|email',
            'status' => 'nullable|string',
        ]);

        $invitation = Invitation::create($request->all());

        return response()->json($invitation, 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Invitation $invitation)
    {
        return response()->json($invitation->load('club'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Invitation $invitation)
    {
        $request->validate([
            'club_id' => 'sometimes|exists:clubs,id',
            'email' => 'sometimes|email',
            'status' => 'sometimes|string',
        ]);

        $invitation->update($request->all());

        return response()->json($invitation);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Invitation $invitation)
    {
        $invitation->delete();

        return response()->json(null, 204);
    }
}
