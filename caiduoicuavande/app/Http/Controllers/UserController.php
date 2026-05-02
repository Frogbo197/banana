<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UserController extends Controller
{
    public function saveUser(Request $request)
    {
        // validate nhẹ
        $request->validate([
            'email' => 'required|email',
            'name'  => 'nullable|string'
        ]);

        $user = DB::table('nguoidung')
            ->where('email', $request->email)
            ->first();
        if (!$user) {
            DB::table('nguoidung')->insert([
                'email' => $request->email,
                'ten'   => $request->name ?? '',
            ]);
        }
        return response()->json([
            'status' => 'ok'
        ]);
    }

    public function saveOnboarding(Request $request)
    {   
        $request->validate([
            'email' => 'required|email',
            'gender' => 'nullable|string',
            'weight' => 'nullable|numeric',
            'age' => 'nullable|integer',
            'blood' => 'nullable|string',
            'fitness' => 'nullable|integer',
            'goal' => 'nullable|array',
        ]);

        $user = DB::table('nguoidung')
            ->where('email', $request->email)
            ->first();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'User chưa tồn tại'
            ], 404);
        }

        DB::table('nguoidung')
            ->where('email', $request->email)
            ->update([
                'gioitinh' => $request->gender,
                'cannang' => $request->weight,
                'tuoi' => $request->age,
                'nhommau' => $request->blood,
                'thetrang' => $request->fitness,
                'muctieu' => json_encode($request->goal),
                'updated_at' => now(),
            ]);

        return response()->json([
            'status' => 'ok'
        ]);
    }
      
    public function getUsers(Request $request)
    {
        if ($request->email) {
            return DB::table('nguoidung')
                ->where('email', $request->email)
                ->first();
        }

        return DB::table('nguoidung')->get();
    }
}