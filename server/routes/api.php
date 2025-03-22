<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\ClubController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\DepartmentController;
use App\Http\Controllers\Api\EventController;
use App\Http\Controllers\Api\FeedbackController;
use App\Http\Controllers\Api\BlogController;
use App\Http\Controllers\Api\JoinRequestController;
use App\Http\Controllers\Api\InvitationController;
use App\Http\Controllers\Api\UserEventController;
use App\Http\Controllers\Api\BackgroundImageController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\RegisterControllerAD;
use App\Http\Controllers\Auth\VerificationController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\LoginControllerAD;
use App\Http\Controllers\Auth\ForgotPasswordController;
use App\Http\Controllers\Auth\ResetPasswordController;
use App\Http\Controllers\Api\NotificationController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::prefix('users')->group(function () {
    Route::get('/', [UserController::class, 'index']);
    Route::post('/', [UserController::class, 'store']);
    Route::get('/{user}', [UserController::class, 'show']);
    Route::match(['put', 'patch', 'post'], '/{user}', [UserController::class, 'update']);
    Route::delete('/{user}', [UserController::class, 'destroy']);
});

Route::prefix('clubs')->group(function () {
    Route::get('/', [ClubController::class, 'index']);
    Route::post('/', [ClubController::class, 'store']);
    Route::get('/{club}', [ClubController::class, 'show']);
    Route::get('/user/{userId}', [ClubController::class, 'getClbUser']);
    Route::match(['put', 'patch', 'post'], '/{club}', [ClubController::class, 'update']);
    Route::delete('/{club}', [ClubController::class, 'destroy']);
});

Route::prefix('categories')->group(function () {
    Route::get('/', [CategoryController::class, 'index']);
    Route::post('/', [CategoryController::class, 'store']);
    Route::get('/{category}', [CategoryController::class, 'show']);
    Route::patch('/{category}', [CategoryController::class, 'update']);
    Route::delete('/{category}', [CategoryController::class, 'destroy']);
});

Route::prefix('departments')->group(function () {
    Route::get('/', [DepartmentController::class, 'index']);
    Route::post('/', [DepartmentController::class, 'store']);
    Route::get('/{department}', [DepartmentController::class, 'show']);
    Route::patch('/{department}', [DepartmentController::class, 'update']);
    Route::delete('/{department}', [DepartmentController::class, 'destroy']);
});

Route::prefix('events')->group(function () {
    Route::get('/club/{event}', [EventController::class, 'showClbEvent']);
    Route::get('/', [EventController::class, 'index']);
    Route::post('/', [EventController::class, 'store']);
    Route::get('/{event}', [EventController::class, 'show']);
    Route::match(['put', 'patch', 'post'], '/{event}', [EventController::class, 'update']); //Update event
    Route::delete('/{event}', [EventController::class, 'destroy']);
});

Route::prefix('feedbacks')->group(function () {
    Route::get('/', [FeedbackController::class, 'index']);
    Route::post('/', [FeedbackController::class, 'store']);
    Route::get('/{feedback}', [FeedbackController::class, 'show']);
    Route::patch('/{feedback}', [FeedbackController::class, 'update']);
    Route::delete('/{feedback}', [FeedbackController::class, 'destroy']);
});

Route::prefix('blogs')->group(function () {
    Route::get('/', [BlogController::class, 'index']);
    Route::post('/', [BlogController::class, 'store']);
    Route::get('/{blog}', [BlogController::class, 'show']);
    Route::match(['put', 'patch', 'post'], '/{blog}', [BlogController::class, 'update']);
    Route::delete('/{blog}', [BlogController::class, 'destroy']);
});

Route::prefix('join-requests')->group(function () {
    Route::get('/', [JoinRequestController::class, 'index']);
    Route::post('/', [JoinRequestController::class, 'store']);
    Route::get('/{joinRequest}', [JoinRequestController::class, 'show']);
    Route::patch('/{joinRequest}', [JoinRequestController::class, 'update']);
    Route::delete('/{joinRequest}', [JoinRequestController::class, 'destroy']);
});

Route::prefix('user-events')->group(function () {
    Route::get('/', [UserEventController::class, 'index']);
    Route::post('/', [UserEventController::class, 'store']);
    Route::get('/{userEvent}', [UserEventController::class, 'show']);
    Route::get('/events/{event_id}', [UserEventController::class, 'getUsersByEvent']); // get users by event id  
    Route::patch('/{userEvent}', [UserEventController::class, 'update']);
    Route::delete('/{userEvent}', [UserEventController::class, 'destroy']);
});

Route::prefix('background-images')->group(function () {
    Route::get('/', [BackgroundImageController::class, 'index']);
    Route::post('/upload-image', [BackgroundImageController::class, 'uploadImage']);
    Route::post('/upload-video', [BackgroundImageController::class, 'uploadVideo']);
    Route::get('/{backgroundImage}', [BackgroundImageController::class, 'show']);
    Route::put('/{backgroundImage}', [BackgroundImageController::class, 'update']);
    Route::delete('/{backgroundImage}/delete-image', [BackgroundImageController::class, 'deleteImage']);
    Route::delete('/{backgroundImage}/delete-video', [BackgroundImageController::class, 'deleteVideo']);
});


Route::prefix('auth')->group(function () {
    Route::post('register', [RegisterController::class, 'register'])->middleware('validate.registration');
    Route::post('verify-email', [VerificationController::class, 'verify']);
    Route::post('login', [LoginController::class, 'login']);
    Route::post('forgotpass', [ForgotPasswordController::class, 'sendResetLinkEmail']);
    Route::post('reset-password', [ResetPasswordController::class, 'resetPassword']);
});


Route::prefix('authad')->group(function () {
    Route::post('login', [LoginControllerAD::class, 'login']);
});

// Notification routes
Route::prefix('notifications')->middleware(['auth:sanctum', 'notifications'])->group(function () {
    Route::get('/', [NotificationController::class, 'index']);
    Route::post('/{id}/mark-as-read', [NotificationController::class, 'markAsRead']);
    Route::post('/mark-all-read', [NotificationController::class, 'markAllAsRead']);
    Route::delete('/{id}', [NotificationController::class, 'destroy']);
    Route::delete('/', [NotificationController::class, 'destroyAll']);
});
