<?php

namespace App\Http\Controllers\Api;

use App\Models\JoinRequest;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class JoinRequestController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return JoinRequest::with(['club', 'user'])->get();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        try {
            // Kiểm tra dữ liệu request
            if (!$request->has('club_id') || !$request->has('user_id')) {
                return response()->json([
                    'message' => 'Missing required fields',
                    'errors' => [
                        'club_id' => 'The club id field is required.',
                        'user_id' => 'The user id field is required.'
                    ]
                ], 422);
            }

            $validatedData = $request->validate([
                'club_id' => 'required|exists:clubs,id',
                'user_id' => 'required|exists:users,id',
                'type' => 'nullable|string',
            ]);

            // Kiểm tra xem user đã có join request pending chưa
            $existingRequest = JoinRequest::where('user_id', $validatedData['user_id'])
                ->where('club_id', $validatedData['club_id'])
                ->where('status', 'pending')
                ->first();

            if ($existingRequest) {
                return response()->json([
                    'message' => 'User already has a pending join request for this club'
                ], 422);
            }

            $joinRequest = JoinRequest::create([
                'club_id' => $validatedData['club_id'],
                'user_id' => $validatedData['user_id'],
                'type' => $validatedData['type'] ?? null,
                'status' => 'pending'
            ]);

            return response()->json([
                'message' => 'Join request created successfully',
                'data' => $joinRequest
            ], 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error creating join request',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(JoinRequest $joinRequest)
    {
        return response()->json($joinRequest->load(['club', 'user']));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, JoinRequest $joinRequest)
    {
        $request->validate([
            'status' => 'sometimes|string|in:pending,accepted,rejected',
        ]);

        $joinRequest->update($request->all());

        return response()->json($joinRequest);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(JoinRequest $joinRequest)
    {
        $joinRequest->delete();

        return response()->json(null, 204);
    }
}
