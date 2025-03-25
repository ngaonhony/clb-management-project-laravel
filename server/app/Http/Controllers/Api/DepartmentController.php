<?php

namespace App\Http\Controllers\Api;

use App\Models\Department;
use App\Models\Club;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DepartmentController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($club_id)
    {
        // Get club with owner information first
        $club = Club::with(['user', 'user.backgroundImages'])->findOrFail($club_id);

        // Get departments with their managers
        $departments = Department::where('club_id', $club_id)
            ->with(['user', 'user.backgroundImages'])
            ->get();

        // Create response structure
        $response = [
            'club' => [
                'id' => $club->id,
                'name' => $club->name,
                'owner' => [
                    'id' => $club->user->id,
                    'username' => $club->user->username,
                    'email' => $club->user->email,
                    'phone' => $club->user->phone,
                    'gender' => $club->user->gender,
                    'description' => $club->user->description,
                    'background_images' => $club->user->backgroundImages
                ]
            ],
            'departments' => $departments
        ];

        return response()->json($response);
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
        'user_id' => 'required|exists:users,id',
        'name' => 'required|string|max:255',
        'description' => 'nullable|string',
        'manage_clubs' => 'sometimes|boolean',
        'manage_events' => 'boolean',
        'manage_members' => 'boolean',
        'manage_blogs' => 'boolean'
    ]);

    $department = Department::create($request->all());
    return response()->json($department, 201);
}

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Department $department)
    {
        return response()->json($department);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Department $department)
{
    $request->validate([
        'club_id' => 'sometimes|exists:clubs,id',
        'user_id' => 'sometimes|exists:users,id',
        'name' => 'sometimes|string|max:255',
        'description' => 'nullable|string',
        'manage_clubs' => 'sometimes|boolean',
        'manage_events' => 'sometimes|boolean',
        'manage_members' => 'sometimes|boolean',
        'manage_blogs' => 'sometimes|boolean'
    ]);

    $department->update($request->all());
    return response()->json($department);
}

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Department $department)
    {
        $department->delete();

        return response()->json(null, 204);
    }
}
