<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
{
    $user = User::findOrFail($id);

    $validatedData = $request->validate([
        'username' => 'sometimes|string|max:255|unique:users,username,' . $user->id,
        'password' => 'sometimes|string|min:6',
        'email' => 'sometimes|email|unique:users,email,' . $user->id,
        'phone' => 'sometimes|string|unique:users,phone,' . $user->id,
        'gender' => 'sometimes|string',
        'profile_picture' => 'sometimes|string',
        'description' => 'sometimes|string',
        'role' => 'sometimes|string',
    ]);
    $user->fill($validatedData);
    if ($request->has('password')) {
        $user->password = bcrypt($request->password);
    }
    $user->save(); 
    return response()->json($user, 200); 
}

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();
    return response()->json(['message' => 'Người dùng đã được xóa thành công'], 200);
    }
}
