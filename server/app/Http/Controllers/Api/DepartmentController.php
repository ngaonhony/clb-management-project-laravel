<?php

namespace App\Http\Controllers\Api;
use App\Models\Department;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DepartmentController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Department::all();
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
            'name' => 'required|string|max:255',
            'manage_events' => 'boolean',
            'create_events' => 'boolean',
            'manage_members' => 'boolean',
            'view_notifications' => 'boolean',
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
    public function show($id)
    {
        $department = Department::findOrFail($id);
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
            'name' => 'sometimes|string|max:255',
            'manage_events' => 'sometimes|boolean',
            'create_events' => 'sometimes|boolean',
            'manage_members' => 'sometimes|boolean',
            'view_notifications' => 'sometimes|boolean',
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
