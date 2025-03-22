<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Blog extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'club_id',
        'description',
        'category_id',
        'content',
        'created_at',
        'updated_at',
    ];

    public function club()
    {
        return $this->belongsTo(Club::class, 'club_id');
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function backgroundImages()
    {
        return $this->hasMany(BackgroundImage::class);
    }
}