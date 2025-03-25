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
            // 1. Validate đầu vào
            $validatedData = $request->validate([
                'user_id' => 'required|exists:users,id',
                'type' => 'required|in:club,event',
                'club_id' => 'required_if:type,club|exists:clubs,id|nullable',
                'event_id' => 'required_if:type,event|exists:events,id|nullable',
                'message' => 'nullable|string|max:500'
            ]);

            // 2. Kiểm tra logic nghiệp vụ
            // 2.1. Kiểm tra nếu là event, không được đăng ký event đã kết thúc
            if ($validatedData['type'] === 'event' && isset($validatedData['event_id'])) {
                $event = \App\Models\Event::find($validatedData['event_id']);
                if ($event && $event->end_date < now()) {
                    return response()->json([
                        'message' => 'Sự kiện đã kết thúc'
                    ], 422);
                }
            }

            // 2.2. Kiểm tra yêu cầu tham gia đã tồn tại
            $existingRequest = JoinRequest::where('user_id', $validatedData['user_id'])
                ->where(function ($query) use ($validatedData) {
                    if ($validatedData['type'] === 'club') {
                        $query->where('club_id', $validatedData['club_id']);
                    } else {
                        $query->where('event_id', $validatedData['event_id']);
                    }
                })
                ->whereIn('status', ['pending', 'approved'])
                ->first();

            if ($existingRequest) {
                $message = $existingRequest->status === 'pending' 
                    ? 'Yêu cầu tham gia đang chờ xử lý' 
                    : 'Bạn đã là thành viên rồi';
                
                return response()->json([
                    'message' => $message
                ], 422);
            }

            // 3. Tạo dữ liệu cho join request
            $joinRequestData = [
                'user_id' => $validatedData['user_id'],
                'type' => $validatedData['type'],
                'status' => 'pending',
                'message' => $validatedData['message'] ?? null,
                'club_id' => $validatedData['type'] === 'club' ? $validatedData['club_id'] : null,
                'event_id' => $validatedData['type'] === 'event' ? $validatedData['event_id'] : null,
                'created_at' => now(),
                'updated_at' => now()
            ];

            // 4. Lưu vào database
            $joinRequest = JoinRequest::create($joinRequestData);

            // 5. Load relationships và trả về response
            $joinRequest->load(['user', 'club', 'event']);

            return response()->json([
                'message' => $validatedData['type'] === 'club' 
                    ? 'Đã gửi yêu cầu tham gia câu lạc bộ thành công'
                    : 'Đã gửi yêu cầu tham gia sự kiện thành công',
                'data' => $joinRequest
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Dữ liệu không hợp lệ',
                'errors' => $e->errors()
            ], 422);

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
