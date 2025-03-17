<?php

namespace App\Http\Controllers\Api;

use App\Models\Club;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class ClubController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $clubs = Club::with('backgroundImages')->get();
        return response()->json($clubs);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'user_id' => 'required|exists:users,id',
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'contact_email' => 'nullable|email',
        ]);
        $club = Club::create(array_merge($validatedData, ['status' => 'pending']));
        return response()->json($club, 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Club $club)
    {
        return response()->json($club->load([
            'category',
            'backgroundImages',
            'events.backgroundImages'
        ]));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function getClbUser($userId)
    {
        // Tìm user dựa trên userId
        $user = User::findOrFail($userId);

        // Lấy danh sách các club của user kèm theo background images có is_logo = 1
        $clubs = $user->clubs()->with(['backgroundImages' => function ($query) {
            $query->where('is_logo', 1);
        }])->get();

        // Trả về thông tin của các club dưới dạng JSON
        return response()->json($clubs);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Club $club)
    {
        $validatedData = $request->validate([
            'user_id' => 'sometimes|exists:users,id',
            'category_id' => 'sometimes|exists:categories,id',
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'contact_email' => 'sometimes|email',
            'contact_phone' => 'sometimes|string',
            'contact_address' => 'sometimes|string',
            'province' => 'sometimes|string',
            'facebook_link' => 'sometimes|string',
            'zalo_link' => 'sometimes|string',
            'status' => 'sometimes|string',
        ]);

        $club->update($validatedData);
        return response()->json($club);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Club $club)
    {
        $club->delete();
        return response()->noContent();
    }
}
