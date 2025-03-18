<?php

namespace App\Listeners;

use App\Events\EventCreated;
use App\Notifications\NewEventNotification;
use App\Models\User;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\DB;

class SendEventCreatedNotification implements ShouldQueue
{
    public function handle(EventCreated $event)
    {
        // Get all users who should be notified
        $users = User::all(); // You can modify this to get specific users based on your requirements

        // Use transaction to ensure atomicity
        DB::transaction(function () use ($users, $event) {
            foreach ($users as $user) {
                // Check if notification already exists
                $exists = DB::table('notifications')
                    ->where('notifiable_id', $user->id)
                    ->whereRaw("JSON_EXTRACT(data, '$.event_id') = ?", [$event->event->id])
                    ->whereRaw("JSON_EXTRACT(data, '$.notification_type') = ?", ['new_event'])
                    ->exists();

                if (!$exists) {
                    $user->notify(new NewEventNotification($event->event));
                }
            }
        });
    }
} 