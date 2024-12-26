<?php

namespace App\Http\Controllers\Api;
use App\Models\BackgroundImage;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class BackgroundImageController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return BackgroundImage::with(['club', 'event'])->get();
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
            'event_id' => 'required|exists:events,id',
            'image_url' => 'required|url',
            'video_url' => 'nullable|url',
        ]);

        $backgroundImage = BackgroundImage::create($request->all());
        return response()->json($backgroundImage, 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(BackgroundImage $backgroundImage)
    {
        return response()->json($backgroundImage->load(['club', 'event']));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, BackgroundImage $backgroundImage)
    {
        $request->validate([
            'club_id' => 'nullable|exists:clubs,id',
            'event_id' => 'nullable|exists:events,id',
            'image_url' => 'nullable|url',
            'video_url' => 'nullable|url',
        ]);

        $backgroundImage->update($request->all());
        return response()->json($backgroundImage);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(BackgroundImage $backgroundImage)
    {
        $backgroundImage->delete();
        return response()->json(null, 204);
    }
}
