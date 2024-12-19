<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Club extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'category_id',
        'name',
        'logo',
        'description',
        'member_count',
        'contact_email',
        'contact_phone',
        'contact_address',
        'province',
        'website',
        'facebook_link',
        'zalo_link',
        'created_at',
        'status',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'user_clubs');
    }

    public function events()
    {
        return $this->hasMany(Event::class);
    }

    public function feedbacks()
    {
        return $this->hasMany(Feedback::class);
    }

    public function blogs()
    {
        return $this->hasMany(Blog::class);
    }

    public function departments()
    {
        return $this->hasMany(Department::class);
    }
}