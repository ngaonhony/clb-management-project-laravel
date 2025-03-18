<?php

namespace App\Notifications;

use App\Models\Event;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class NewEventNotification extends Notification implements ShouldQueue
{
    use Queueable;

    protected $event;

    public function __construct(Event $event)
    {
        $this->event = $event;
    }

    public function via($notifiable)
    {
        return ['database', 'mail'];
    }

    public function toMail($notifiable)
    {
        return (new MailMessage)
            ->subject('New Event Created')
            ->line('A new event has been created: ' . $this->event->name)
            ->line('Start Date: ' . $this->event->start_date)
            ->line('Location: ' . $this->event->location)
            ->action('View Event', url('/events/' . $this->event->id))
            ->line('Thank you for using our application!');
    }

    public function toArray($notifiable)
    {
        return [
            'event_id' => $this->event->id,
            'event_name' => $this->event->name,
            'start_date' => $this->event->start_date,
            'location' => $this->event->location,
            'notification_type' => 'new_event'
        ];
    }

    public function toDatabase($notifiable)
    {
        return $this->toArray($notifiable);
    }
} 