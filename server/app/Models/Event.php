<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    use HasFactory;

    protected $fillable = [
        'club_id',
        'category_id',
        'name',
        'start_date',
        'end_date',
        'location',
        'max_participants',
        'registered_participants',
        'content',
        'logo',
        'status',
    ];

    public function club()
    {
        return $this->belongsTo(Club::class);
    }

    public function users()
    {
        return $this->belongsToMany(User::class, 'user_events');
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }
}