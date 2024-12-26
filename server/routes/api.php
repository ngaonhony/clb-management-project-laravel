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
    Route::get('/{user}', [UserController::class, 'show']);  
    Route::patch('/{user}', [UserController::class, 'update']); 
    Route::delete('/{user}', [UserController::class, 'destroy']);  
});
 
Route::prefix('clubs')->group(function () {
    Route::get('/', [ClubController::class, 'index']);
    Route::post('/', [ClubController::class, 'store']);
    Route::get('/{club}', [ClubController::class, 'show']);  
    Route::patch('/{club}', [ClubController::class, 'update']); 
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
    Route::get('/', [EventController::class, 'index']);
    Route::post('/', [EventController::class, 'store']);
    Route::get('/{event}', [EventController::class, 'show']); 
    Route::patch('/{event}', [EventController::class, 'update']);  
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
    Route::patch('/{blog}', [BlogController::class, 'update']);  
    Route::delete('/{blog}', [BlogController::class, 'destroy']);
});

Route::prefix('join-requests')->group(function () {
    Route::get('/', [JoinRequestController::class, 'index']);
    Route::post('/', [JoinRequestController::class, 'store']);
    Route::get('/{joinRequest}', [JoinRequestController::class, 'show']); 
    Route::patch('/{joinRequest}', [JoinRequestController::class, 'update']);
    Route::delete('/{joinRequest}', [JoinRequestController::class, 'destroy']); 
});

Route::prefix('invitations')->group(function () {
    Route::get('/', [InvitationController::class, 'index']);
    Route::post('/', [InvitationController::class, 'store']);
    Route::get('/{invitation}', [InvitationController::class, 'show']); 
    Route::patch('/{invitation}', [InvitationController::class, 'update']);
    Route::delete('/{invitation}', [InvitationController::class, 'destroy']);
});

Route::prefix('user-events')->group(function () {
    Route::get('/', [UserEventController::class, 'index']);
    Route::post('/', [UserEventController::class, 'store']);
    Route::get('/{userEvent}', [UserEventController::class, 'show']); 
    Route::patch('/{userEvent}', [UserEventController::class, 'update']);
    Route::delete('/{userEvent}', [UserEventController::class, 'destroy']); 
});

Route::prefix('background-images')->group(function () {
    Route::get('/', [BackgroundImageController::class, 'index']);
    Route::post('/', [BackgroundImageController::class, 'store']);
    Route::get('/{backgroundImage}', [BackgroundImageController::class, 'show']); 
    Route::patch('/{backgroundImage}', [BackgroundImageController::class, 'update']);
    Route::delete('/{backgroundImage}', [BackgroundImageController::class, 'destroy']); 
});