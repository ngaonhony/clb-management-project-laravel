<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable = [
        'club_id',
        'user_id',
        'name',
        'manage_events',
        'create_events',
        'manage_members',
        'view_notifications',
        'create_blogs',
    ];
    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function club()
    {
        return $this->belongsTo(Club::class);
    }
}