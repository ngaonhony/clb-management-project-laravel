<?php

namespace App\Http\Controllers\Api;
use App\Models\Blog;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class BlogController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Blog::with('user', 'category')->get();
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
            'title' => 'required|string|max:255',
            'author_id' => 'required|exists:users,id',
            'description' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
            'view_count' => 'integer',
            'logo' => 'nullable|string',
            'content' => 'required|string',
        ]);

        $blog = Blog::create($request->all());

        return response()->json($blog, 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Blog $blog)
    {
        return response()->json($blog->load('user', 'category'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Blog $blog)
    {
        $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'author_id' => 'sometimes|required|exists:users,id',
            'description' => 'nullable|string',
            'category_id' => 'sometimes|required|exists:categories,id',
            'view_count' => 'sometimes|integer',
            'logo' => 'nullable|string',
            'content' => 'sometimes|required|string',
        ]);

        $blog->update($request->all());

        return response()->json($blog);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Blog $blog)
    {
        $blog->delete();

        return response()->json(null, 204);
    }
}
