<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\ClubController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\DepartmentController;
use App\Http\Controllers\EventController;
use App\Http\Controllers\FeedbackController;
use App\Http\Controllers\BlogController;
use App\Http\Controllers\JoinRequestController;
use App\Http\Controllers\InvitationController;
use App\Http\Controllers\UserClubController;
use App\Http\Controllers\UserEventController;
use App\Http\Controllers\BackgroundImageController;

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
    Route::get('/{id}', [UserController::class, 'show']);
    Route::patch('/{id}', [UserController::class, 'update']);
    Route::delete('/{id}', [UserController::class, 'destroy']);
});

Route::prefix('clubs')->group(function () {
    Route::get('/', [ClubController::class, 'index']);
    Route::post('/', [ClubController::class, 'store']);
    Route::get('/{id}', [ClubController::class, 'show']);
    Route::patch('/{id}', [ClubController::class, 'update']);
    Route::delete('/{id}', [ClubController::class, 'destroy']);
});

Route::prefix('categories')->group(function () {
    Route::get('/', [CategoryController::class, 'index']);
    Route::post('/', [CategoryController::class, 'store']);
    Route::get('/{id}', [CategoryController::class, 'show']);
    Route::patch('/{id}', [CategoryController::class, 'update']);
    Route::delete('/{id}', [CategoryController::class, 'destroy']);
});

Route::prefix('departments')->group(function () {
    Route::get('/', [DepartmentController::class, 'index']);
    Route::post('/', [DepartmentController::class, 'store']);
    Route::get('/{id}', [DepartmentController::class, 'show']);
    Route::patch('/{id}', [DepartmentController::class, 'update']);
    Route::delete('/{id}', [DepartmentController::class, 'destroy']);
});

Route::prefix('events')->group(function () {
    Route::get('/', [EventController::class, 'index']);
    Route::post('/', [EventController::class, 'store']);
    Route::get('/{id}', [EventController::class, 'show']);
    Route::patch('/{id}', [EventController::class, 'update']);
    Route::delete('/{id}', [EventController::class, 'destroy']);
});

Route::prefix('feedback')->group(function () {
    Route::get('/', [FeedbackController::class, 'index']);
    Route::post('/', [FeedbackController::class, 'store']);
    Route::get('/{id}', [FeedbackController::class, 'show']);
    Route::patch('/{id}', [FeedbackController::class, 'update']);
    Route::delete('/{id}', [FeedbackController::class, 'destroy']);
});

Route::prefix('blogs')->group(function () {
    Route::get('/', [BlogController::class, 'index']);
    Route::post('/', [BlogController::class, 'store']);
    Route::get('/{id}', [BlogController::class, 'show']);
    Route::patch('/{id}', [BlogController::class, 'update']);
    Route::delete('/{id}', [BlogController::class, 'destroy']);
});

Route::prefix('join-requests')->group(function () {
    Route::get('/', [JoinRequestController::class, 'index']);
    Route::post('/', [JoinRequestController::class, 'store']);
    Route::get('/{id}', [JoinRequestController::class, 'show']);
    Route::patch('/{id}', [JoinRequestController::class, 'update']);
    Route::delete('/{id}', [JoinRequestController::class, 'destroy']);
});

Route::prefix('invitations')->group(function () {
    Route::get('/', [InvitationController::class, 'index']);
    Route::post('/', [InvitationController::class, 'store']);
    Route::get('/{id}', [InvitationController::class, 'show']);
    Route::patch('/{id}', [InvitationController::class, 'update']);
    Route::delete('/{id}', [InvitationController::class, 'destroy']);
});

Route::prefix('user-clubs')->group(function () {
    Route::get('/', [UserClubController::class, 'index']);
    Route::post('/', [UserClubController::class, 'store']);
    Route::get('/{id}', [UserClubController::class, 'show']);
    Route::patch('/{id}', [UserClubController::class, 'update']);
    Route::delete('/{id}', [UserClubController::class, 'destroy']);
});

Route::prefix('user-events')->group(function () {
    Route::get('/', [UserEventController::class, 'index']);
    Route::post('/', [UserEventController::class, 'store']);
    Route::get('/{id}', [UserEventController::class, 'show']);
    Route::patch('/{id}', [UserEventController::class, 'update']);
    Route::delete('/{id}', [UserEventController::class, 'destroy']);
});

Route::prefix('background-images')->group(function () {
    Route::get('/', [BackgroundImageController::class, 'index']);
    Route::post('/', [BackgroundImageController::class, 'store']);
    Route::get('/{id}', [BackgroundImageController::class, 'show']);
    Route::patch('/{id}', [BackgroundImageController::class, 'update']);
    Route::delete('/{id}', [BackgroundImageController::class, 'destroy']);
});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
