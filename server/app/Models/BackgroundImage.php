<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BackgroundImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'club_id',
        'image_url',
    ];
    public function club()
    {
        return $this->belongsTo(Club::class);
    }
}