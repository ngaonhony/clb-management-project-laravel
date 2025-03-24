<?php

namespace App\Http\Controllers\Api;

use App\Models\JoinRequest;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class JoinRequestController extends Controller
{
    /**
     * Lấy tất cả join requests theo club_id
     */
    public function getClubRequests($club_id)
    {
        return JoinRequest::with(['user', 'user.backgroundImages'])
            ->where('club_id', $club_id)
            ->where('type', 'club')
            ->get();
    }

    /**
     * Lấy tất cả join requests theo event_id
     */
    public function getEventRequests($event_id)
    {
        return JoinRequest::with(['user', 'user.backgroundImages'])
            ->where('event_id', $event_id)
            ->where('type', 'event')
            ->get();
    }

    /**
     * Lấy tất cả join requests của một user
     */
    public function getUserRequests($user_id)
    {
        return JoinRequest::with(['club', 'event'])
            ->where('user_id', $user_id)
            ->get();
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
            $validatedData = $request->validate([
                'user_id' => 'required|exists:users,id',
                'type' => 'required|in:club,event',
                'club_id' => 'required_if:type,club|exists:clubs,id|nullable',
                'event_id' => 'required_if:type,event|exists:events,id|nullable',
                'message' => 'nullable|string'
            ]);

            // Kiểm tra yêu cầu tham gia đã tồn tại chưa
            $existingRequest = JoinRequest::where('user_id', $validatedData['user_id'])
                ->where(function ($query) use ($validatedData) {
                    if ($validatedData['type'] === 'club') {
                        $query->where('club_id', $validatedData['club_id']);
                    } else {
                        $query->where('event_id', $validatedData['event_id']);
                    }
                })
                ->where('status', 'pending')
                ->first();

            if ($existingRequest) {
                return response()->json([
                    'message' => 'Yêu cầu tham gia đang chờ xử lý'
                ], 422);
            }

            $joinRequest = JoinRequest::create($validatedData);

            return response()->json([
                'message' => 'Đã gửi yêu cầu tham gia thành công',
                'data' => $joinRequest->load(['user', 'club', 'event'])
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Lỗi khi tạo yêu cầu tham gia',
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
        $validatedData = $request->validate([
            'status' => 'required|in:approved,rejected',
            'response_message' => 'nullable|string'
        ]);

        // Tạo mảng dữ liệu cập nhật
        $updateData = [
            'status' => $validatedData['status'],
            'responded_at' => now()
        ];

        // Chỉ thêm response_message nếu nó được cung cấp
        if (isset($validatedData['response_message'])) {
            $updateData['response_message'] = $validatedData['response_message'];
        }

        $joinRequest->update($updateData);

        return response()->json([
            'message' => 'Đã cập nhật trạng thái yêu cầu',
            'data' => $joinRequest->load(['user', 'club', 'event'])
        ]);
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
