<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

Route::post('/save-user', [UserController::class, 'saveUser']);
Route::post('/save-onboarding', [UserController::class, 'saveOnboarding']);
Route::get('/users', [UserController::class, 'getUsers']);