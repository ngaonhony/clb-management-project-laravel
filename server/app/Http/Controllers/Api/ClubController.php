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
        $clubs = Club::with('backgroundImages')->orderBy('id', 'desc')->get();
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

        // Create join request for the creator
        \App\Models\JoinRequest::create([
            'user_id' => $validatedData['user_id'],
            'club_id' => $club->id,
            'type' => 'club',
            'status' => 'approved',
            'responded_at' => now()
        ]);

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
            'user',
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
     * @param  Club  $club
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Club $club)
    {
        try {
            // 1. Validate tất cả dữ liệu đầu vào
            $this->validateUpdateRequest($request);

            // 2. Cập nhật thông tin cơ bản của club
            $club->update($request->except(['logo', 'images', 'deleted_image_ids']));

            // 3. Xử lý ảnh đại diện (logo)
            if ($request->hasFile('logo')) {
                $this->handleLogoUpload($club, $request->file('logo'));
            }

            // 4. Xử lý upload nhiều ảnh
            if ($request->hasFile('images')) {
                $this->handleImagesUpload($club, $request->file('images'));
            }

            // 5. Xử lý xóa ảnh
            if ($request->has('deleted_image_ids')) {
                $this->handleImageDeletions($club, $request->deleted_image_ids);
            }

            // 6. Load relationships và trả về response
            return response()->json([
                'message' => 'Cập nhật câu lạc bộ thành công',
                'data' => $club->load(['user', 'category', 'backgroundImages'])
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Dữ liệu không hợp lệ',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Lỗi khi cập nhật câu lạc bộ',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Validate dữ liệu cập nhật
     */
    private function validateUpdateRequest(Request $request)
    {
        // Validate thông tin cơ bản
        $rules = [
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
            'status' => 'sometimes|string|in:active,inactive'
        ];

        // Thêm rules cho files nếu có
        if ($request->hasFile('logo')) {
            $rules['logo'] = 'image|mimes:jpeg,png,jpg,gif|max:2048';
        }

        if ($request->hasFile('images')) {
            $rules['images.*'] = 'image|mimes:jpeg,png,jpg,gif|max:2048';
        }

        return validator($request->all(), $rules)->validate();
    }

    /**
     * Xử lý upload logo
     */
    private function handleLogoUpload(Club $club, $logoFile)
    {
        // Xóa logo cũ nếu có
        $existingLogo = $club->backgroundImages()->where('is_logo', 1)->first();
        if ($existingLogo) {
            $existingLogo->deleteImage();
            $existingLogo->delete();
        }

        // Upload logo mới
        $backgroundImage = new \App\Models\BackgroundImage();
        $backgroundImage->club_id = $club->id;
        $backgroundImage->is_logo = 1;
        $backgroundImage->uploadImage($logoFile);
    }

    /**
     * Xử lý upload nhiều ảnh
     */
    private function handleImagesUpload(Club $club, array $images)
    {
        foreach ($images as $image) {
            $backgroundImage = new \App\Models\BackgroundImage();
            $backgroundImage->club_id = $club->id;
            $backgroundImage->is_logo = 0;
            $backgroundImage->uploadImage($image);
        }
    }

    /**
     * Xử lý xóa ảnh
     */
    private function handleImageDeletions(Club $club, string $deletedImageIds)
    {
        $imageIds = explode(',', $deletedImageIds);
        $imagesToDelete = $club->backgroundImages()
            ->whereIn('id', $imageIds)
            ->where('is_logo', 0)
            ->get();

        foreach ($imagesToDelete as $image) {
            $image->deleteImage();
            $image->delete();
        }
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

    /**
     * Tìm kiếm và lọc danh sách câu lạc bộ
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function search(Request $request)
    {
        $query = Club::query();

        // Tìm kiếm theo tên câu lạc bộ (tìm kiếm mờ)
        if ($request->has('name')) {
            $query->where('name', 'like', '%' . $request->name . '%');
        }

        // Tìm kiếm theo ID của người tạo
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Tìm kiếm theo ID của danh mục
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Tìm kiếm theo mô tả (tìm kiếm mờ)
        if ($request->has('description')) {
            $query->where('description', 'like', '%' . $request->description . '%');
        }

        // Tìm kiếm theo số lượng thành viên
        if ($request->has('min_members')) {
            $query->where('member_count', '>=', $request->min_members);
        }
        
        if ($request->has('max_members')) {
            $query->where('member_count', '<=', $request->max_members);
        }

        // Tìm kiếm theo email liên hệ (tìm kiếm mờ)
        if ($request->has('contact_email')) {
            $query->where('contact_email', 'like', '%' . $request->contact_email . '%');
        }

        // Tìm kiếm theo số điện thoại liên hệ (tìm kiếm mờ)
        if ($request->has('contact_phone')) {
            $query->where('contact_phone', 'like', '%' . $request->contact_phone . '%');
        }

        // Tìm kiếm theo địa chỉ liên hệ (tìm kiếm mờ)
        if ($request->has('contact_address')) {
            $query->where('contact_address', 'like', '%' . $request->contact_address . '%');
        }

        // Tìm kiếm theo tỉnh/thành phố (tìm kiếm mờ)
        if ($request->has('province')) {
            $query->where('province', 'like', '%' . $request->province . '%');
        }

        // Tìm kiếm theo trạng thái
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Tìm kiếm theo nhiều trạng thái
        if ($request->has('statuses')) {
            $statuses = explode(',', $request->statuses);
            $query->whereIn('status', $statuses);
        }

        // Sắp xếp kết quả
        if ($request->has('sort_by')) {
            $sortDirection = $request->has('sort_direction') ? $request->sort_direction : 'asc';
            $query->orderBy($request->sort_by, $sortDirection);
        } else {
            // Mặc định sắp xếp theo ID
            $query->orderBy('id', 'desc');
        }

        // Tải các quan hệ
        $query->with(['user', 'category', 'backgroundImages']);

        // Trả về kết quả với phân trang nếu cần
        $perPage = $request->has('per_page') ? $request->per_page : 10;

        if ($request->has('paginate') && $request->paginate === 'false') {
            $clubs = $query->get();
            return response()->json($clubs);
        } else {
            $clubs = $query->paginate($perPage);
            return response()->json($clubs);
        }
    }

    // /**
    //  * Get club members list
    //  *
    //  * @param  int  $id
    //  * @return \Illuminate\Http\Response
    //  */
    // public function getMembers($id)
    // {
    //     $club = Club::findOrFail($id);
        
    //     // Get club owner
    //     $owner = $club->user;
        
    //     // Get approved members through join requests
    //     $members = \App\Models\JoinRequest::where('club_id', $id)
    //         ->where('status', 'approved')
    //         ->with('user')
    //         ->get()
    //         ->map(function ($request) {
    //             return [
    //                 'id' => $request->user->id,
    //                 'name' => $request->user->username,
    //                 'email' => $request->user->email,
    //                 'phone' => $request->user->phone,
    //                 'role' => $request->role ?? 'Thành viên',
    //                 'department' => $request->department ?? 'Thành viên',
    //                 'avatar' => $request->user->avatar ?? null
    //             ];
    //         });

    //     // Add club owner to the beginning of the list
    //     $members->prepend([
    //         'id' => $owner->id,
    //         'name' => $owner->username,
    //         'email' => $owner->email,
    //         'phone' => $owner->phone,
    //         'role' => 'Chủ Câu Lạc Bộ',
    //         'department' => 'Ban Điều Hành',
    //         'avatar' => $owner->avatar ?? null
    //     ]);

    //     return response()->json($members);
    // }
}
