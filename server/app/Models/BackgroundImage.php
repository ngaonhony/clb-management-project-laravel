<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BackgroundImage extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable = [
        'club_id',
        'event_id',
        'image_url',
        'video_url',
    ];
    public function club()
    {
        return $this->belongsTo(Club::class);
    }
    public function event()
    {
        return $this->belongsTo(Event::class);
    }
}