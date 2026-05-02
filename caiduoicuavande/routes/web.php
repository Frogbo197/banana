<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

Route::post('/save-user', [UserController::class, 'saveUser']);
Route::get('/', function () {
    return view('welcome');
});
