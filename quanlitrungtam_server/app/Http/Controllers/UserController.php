<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\user_account;
use App\Models\language;
use App\Models\course;


class UserController extends Controller
{
    //ĐĂNG NHẬP ADMIN
    public function login(Request $req){
        $rules = [
            'email' =>'required',
            'password' => 'required',
            'type' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 430);
        }
        // if(Auth::attempt(['email' => $req->email, 'password' => $req->password], true)){
        //     $token = Auth::user()->createToken('Personal Access Token')->plainTextToken;
        //     $response = [ 'user' => Auth::user(), 'token' =>$token ];
        //     return response()->json($response, 200);
        // }
        $user = user_account::where('email', $req->email)->first();
        if($user != null){
            if($user->type != $req->type){
                return response()->json([ 'message' => 'Sai email hoặc mật khẩu'], 430);
            }
    
            if ($token = auth()->attempt(request(['email', 'password']))) {
                return response()->json(['token' => $token, 'user' => $user ], 200);
            }
        }
        
        $response = [ 'message' => 'Sai email hoặc mật khẩu' ];
        return response()->json($response, 430);
    }


    //ĐĂNG NHẬP CỦA GIÁO VIÊN VÀ HỌC VIÊN
    public function login2(Request $req){
        $rules = [
            'email' =>'required',
            'password' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 430);
        }
        // if(Auth::attempt(['email' => $req->email, 'password' => $req->password], true)){
        //     $token = Auth::user()->createToken('Personal Access Token')->plainTextToken;
        //     $response = [ 'user' => Auth::user(), 'token' =>$token ];
        //     return response()->json($response, 200);
        // }
        $user = user_account::where('email', $req->email)->first();
        if($user != null){
            if($user->type == 1){
                return response()->json([ 'message' => 'Sai email hoặc mật khẩu'], 430);
            }
    
            if ($token = auth()->attempt(request(['email', 'password']))) {
                return response()->json(['token' => $token, 'user' => $user ], 200);
            }
        }
        
        $response = [ 'message' => 'Sai email hoặc mật khẩu' ];
        return response()->json($response, 430);
    }


    //KIỂM TRA TÀI KHOẢN
    public function testlogin(){
        $response = [ 'message' => 'Oke' ];
        if(Auth::check())
        return response()->json($response, 200);
        else {
            $response = [ 'message' => 'Chưa đăng nhập' ];
            return response()->json($response, 430);
        }
    }

    public function testlogin2(){
        if(auth()->user() != null) return response()->json(auth()->user());
        else return 0;
    }


    //ĐĂNG XUẤT
    public function logout(Request $req){
        auth()->logout();
        $response = [ 'message' => 'Logout thành công' ];
        return response()->json($response, 200);
    }

}
