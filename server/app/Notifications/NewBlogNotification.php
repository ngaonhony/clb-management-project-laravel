<?php

namespace App\Notifications;

use App\Models\Blog;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class NewBlogNotification extends Notification implements ShouldQueue
{
    use Queueable;

    protected $blog;

    public function __construct(Blog $blog)
    {
        $this->blog = $blog;
    }

    public function via($notifiable)
    {
        return ['database', 'mail'];
    }

    public function toMail($notifiable)
    {
        return (new MailMessage)
            ->subject('New Blog Post')
            ->line('A new blog post has been published: ' . $this->blog->title)
            ->line('Author: ' . $this->blog->user->username)
            ->line('Description: ' . $this->blog->description)
            ->action('Read Blog', url('/blogs/' . $this->blog->id))
            ->line('Thank you for using our application!');
    }

    public function toArray($notifiable)
    {
        return [
            'blog_id' => $this->blog->id,
            'blog_title' => $this->blog->title,
            'author_name' => $this->blog->user->username,
            'description' => $this->blog->description,
            'notification_type' => 'new_blog'
        ];
    }

    public function toDatabase($notifiable)
    {
        return $this->toArray($notifiable);
    }
} 