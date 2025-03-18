<?php

namespace App\Listeners;

use App\Events\BlogCreated;
use App\Notifications\NewBlogNotification;
use App\Models\User;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\DB;

class SendBlogCreatedNotification implements ShouldQueue
{
    public function handle(BlogCreated $event)
    {
        // Get all users who should be notified
        $users = User::all(); // You can modify this to get specific users based on your requirements

        // Use transaction to ensure atomicity
        DB::transaction(function () use ($users, $event) {
            foreach ($users as $user) {
                // Check if notification already exists
                $exists = DB::table('notifications')
                    ->where('notifiable_id', $user->id)
                    ->whereRaw("JSON_EXTRACT(data, '$.blog_id') = ?", [$event->blog->id])
                    ->whereRaw("JSON_EXTRACT(data, '$.notification_type') = ?", ['new_blog'])
                    ->exists();

                if (!$exists) {
                    $user->notify(new NewBlogNotification($event->blog));
                }
            }
        });
    }
} 