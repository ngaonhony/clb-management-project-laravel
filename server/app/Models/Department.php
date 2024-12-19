<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
    use HasFactory;

    protected $fillable = [
        'club_id',
        'name',
        'manage_events',
        'create_events',
        'manage_members',
        'view_notifications',
    ];

    public function club()
    {
        return $this->belongsTo(Club::class);
    }
}