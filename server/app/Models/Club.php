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
        'description',
        'member_count',
        'contact_email',
        'contact_phone',
        'contact_address',
        'province',
        'website',
        'facebook_link',
        'zalo_link',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function departments()
    {
        return $this->hasMany(Department::class);
    }

    public function events()
    {
        return $this->hasMany(Event::class);
    }

    public function feedbacks()
    {
        return $this->hasMany(Feedback::class);
    }

    public function joinRequests()
    {
        return $this->hasMany(JoinRequest::class);
    }

    public function backgroundImages()
    {
        return $this->hasMany(BackgroundImage::class);
    }
}