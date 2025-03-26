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
        $validatedData = $request->validate([
            'user_id' => 'required|exists:users,id',
            'type' => 'required|in:club,event',
            'club_id' => 'required_if:type,club|nullable|exists:clubs,id',
            'event_id' => 'required_if:type,event|nullable|exists:events,id',
            'message' => 'nullable|string|max:500'
        ]);

        // Kiểm tra xem đã có yêu cầu đang pending chưa
        $existingRequest = JoinRequest::where('user_id', $validatedData['user_id'])
            ->when($validatedData['type'] === 'club', function ($query) use ($validatedData) {
                return $query->where('club_id', $validatedData['club_id'])
                    ->where('type', 'club');
            })
            ->when($validatedData['type'] === 'event', function ($query) use ($validatedData) {
                return $query->where('event_id', $validatedData['event_id'])
                    ->where('type', 'event');
            })
            ->where('status', 'pending')
            ->first();

        if ($existingRequest) {
            return response()->json([
                'message' => 'Người dùng đã có yêu cầu tham gia ' . 
                    ($validatedData['type'] === 'club' ? 'câu lạc bộ' : 'sự kiện') . ' này đang chờ duyệt',
                'request' => $existingRequest->load(['user', 'club', 'event'])
            ], 409);
        }

        // Tạo yêu cầu mới
        $joinRequest = new JoinRequest();
        $joinRequest->user_id = $validatedData['user_id'];
        $joinRequest->type = $validatedData['type'];
        $joinRequest->status = 'pending';
        $joinRequest->message = $validatedData['message'] ?? null;

        if ($validatedData['type'] === 'club') {
            $joinRequest->club_id = $validatedData['club_id'];
            $joinRequest->event_id = null;
        } else {
            $joinRequest->event_id = $validatedData['event_id'];
            $joinRequest->club_id = null;
        }

        $joinRequest->save();

        return response()->json([
            'message' => 'Đã gửi yêu cầu tham gia thành công',
            'data' => $joinRequest->load(['user', 'club', 'event'])
        ], 201);
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

    /**
     * Kiểm tra trạng thái tham gia club của user
     */
    public function checkClubStatus($user_id, $club_id)
    {
        $request = JoinRequest::where('user_id', $user_id)
            ->where('club_id', $club_id)
            ->where('type', 'club')
            ->latest()
            ->first();

        if (!$request) {
            return response()->json([
                'status' => 'not_joined',
                'message' => 'Chưa tham gia câu lạc bộ'
            ]);
        }

        return response()->json([
            'status' => $request->status,
            'message' => match ($request->status) {
                'pending' => 'Đang chờ duyệt',
                'approved' => 'Đã là thành viên',
                'rejected' => 'Yêu cầu bị từ chối',
                default => 'Trạng thái không xác định'
            },
            'request' => $request
        ]);
    }

    /**
     * Kiểm tra trạng thái tham gia event của user
     */
    public function checkEventStatus($user_id, $event_id)
    {
        $request = JoinRequest::where('user_id', $user_id)
            ->where('event_id', $event_id)
            ->where('type', 'event')
            ->latest()
            ->first();

        if (!$request) {
            return response()->json([
                'status' => 'not_joined',
                'message' => 'Chưa đăng ký sự kiện'
            ]);
        }

        return response()->json([
            'status' => $request->status,
            'message' => match ($request->status) {
                'pending' => 'Đang chờ duyệt',
                'approved' => 'Đã đăng ký thành công',
                'rejected' => 'Yêu cầu bị từ chối',
                default => 'Trạng thái không xác định'
            },
            'request' => $request
        ]);
    }
}
