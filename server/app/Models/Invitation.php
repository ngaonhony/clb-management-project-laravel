<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Invitation extends Model
{
    use HasFactory;

    protected $fillable = [
        'club_id',
        'email',
        'status',
        'created_at',
    ];

    public function user()
    {
        return $this->hasOne(User::class, 'email', 'email');
    }
}