<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\user_account;
use App\Models\room;
use App\Models\registration;
use App\Models\language;
use App\Models\course;
use App\Models\class_room;
use App\Models\schedule;
use App\Models\schedule_temp;

class AdminController extends Controller
{
    //---------VỚI TÀI KHOẢN--------
    //Thêm tài khoản mới
    public function newuser(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'name' =>'required',
            'type' => 'required|integer',
            'email' => 'required',
            'password' => 'required|min:6',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $name = $req->name;
        $type = $req->type;
        $email = $req->email;
        $password = $req->password;
        $phone = $req->phone;
        if(user_account::where('email', $email)->exists()){
            $response = ['message' => 'Email đã được sử dụng'];
            return response()->json($response, 430);
        }
        $newUser = new user_account;
        $newUser->name = $name;
        $newUser->type = $type;
        $newUser->email = $email;
        $newUser->password = Hash::make($password);
        $newUser->phone = $phone;
        $newUser->save();

        return response()->json($response, 200);
    }

    //Xóa tài khoản
    public function deleteuser(Request $req){
        $response = [ 'message' => 'Đã xóa tài khoản người dùng'];

        $id = $req->account_id;

        $user = user_account::where('account_id',$id)->first();
        if($user == NULL){
            $response = ['message' => 'Không tìm thấy người dùng'];
            return response()->json($response, 430);
        }

        $user->delete();
        return response()->json($response, 200);
    }

    //Sửa người dùng
    public function edituser(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'name' =>'required',
            'type' => 'required|integer',
            // 'email' => 'required',
            // 'password' => 'required|min:6',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $account_id = $req->account_id;
        $name = $req->name;
        $type = $req->type;
        // $email = $req->email;
        // $password = $req->password;
        $phone = $req->phone;

        // if(user_account::where('email', $email)->exists()){
        //     $response = ['message' => 'Email đã được sử dụng'];
        //     return response()->json($response, 430);
        // }
        $user = user_account::where('account_id',$account_id)->first();
        if($user == NULL){
            $response = ['message' => 'Không tìm thấy tài khoản người dùng'];
            return response()->json($response, 430);
        }

        $user->name = $name;
        $user->type = $type;
        // $user->email = $email;
        // $user->password = Hash::make($password);
        $user->phone = $phone;
        $user->save();

        return response()->json($response, 200);
    }

    //---------VỚI NGÔN NGỮ---------
    //Thêm mới lớp học
    public function newlanguage(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'name' =>'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $name = $req->name;

        $newLang = new language;
        $newLang->name = $name;

        $newLang->save();

        return response()->json($response, 200);
    }

    //Xóa ngôn ngữ
    public function deletelanguage(Request $req){
        $response = [ 'message' => 'Đã xóa ngôn ngữ'];

        $id = $req->language_id;

        $language = language::where('language_id',$id)->first();
        if($language == NULL){
            $response = ['message' => 'Không tìm thấy khóa học'];
            return response()->json($response, 430);
        }

        $language->delete();
        return response()->json($response, 200);
    }

    //---------VỚI KHÓA HỌC---------
    //Thêm mới khóa học
    public function newcourse(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'name' =>'required',
            // 'max_mem' =>'required',
            'lessons' =>'required',
            'cost' =>'required',
            'language_id' =>'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $name = $req->name;
        // $max_mem = $req->max_mem;
        $cost = $req->cost;
        $language_id = $req->language_id;
        $lessons = $req->lessons;

        $newCourse = new course;
        $newCourse->name = $name;
        // $newCourse->max_mem = $max_mem;
        $newCourse->cost = $cost;
        $newCourse->language_id = $language_id;
        $newCourse->lessons = $lessons;

        $newCourse->save();

        return response()->json($response, 200);
    }

    //Xóa khóa học
    public function deletecourse(Request $req){
        $response = [ 'message' => 'Đã xóa khóa học'];

        $id = $req->course_id;

        $course = course::where('course_id',$id)->first();
        if($course == NULL){
            $response = ['message' => 'Không tìm thấy khóa học'];
            return response()->json($response, 430);
        }

        $course->delete();
        return response()->json($response, 200);
    }

    //sửa khóa học
    public function editcourse(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'course_id'=>'required',
            'name' =>'required',
            // 'max_mem' =>'required',
            'lessons' =>'required',
            'cost' =>'required',
            'language_id' =>'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $course_id = $req->course_id;
        $name = $req->name;
        // $max_mem = $req->max_mem;
        $cost = $req->cost;
        $language_id = $req->language_id;
        $lessons = $req->lessons;


        $course = course::where('course_id',$course_id)->first();
        if($course == NULL){
            $response = ['message' => 'Không tìm thấy khóa học'];
            return response()->json($response, 430);
        }

        $course->name = $name;
        // $course->max_mem = $max_mem;
        $course->cost = $cost;
        $course->language_id = $language_id;
        $course->lessons = $lessons;

        $course->save();

        return response()->json($response, 200);
    }

    //---------VỚI LỚP HỌC "MỚI"---------
    //Thêm mới lớp học
    public function newroomS(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'room_name' =>'required',
            'max_mem' => 'required|integer',
            'date_start' => 'required|date_format:D Y-m-d',
            'time_start' => 'required|date_format:H:i:s',
            'time_end' => 'required|date_format:H:i:s|after:time_start',
            'account_id' =>'required|integer',
            'course_id' =>'required|integer',
            'classroom_id' =>'required|integer'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $room_name = $req->room_name;
        $max_mem = $req->max_mem;
        $date_start = $req->date_start;
        // $date_start = Carbon::parse($req->date_start)->format('Y-m-d');
        $time_start = $req->time_start;
        $time_end = $req->time_end;
        $account_id = $req->account_id;
        $course_id = $req->course_id;
        $classroom_id = $req->classroom_id;


        if((Carbon::parse($date_start)->format('D') != 'Mon') && (Carbon::parse($date_start)->format('D') != 'Tue')){
            $response = [ 'message ' => 'Buổi học đầu phải là Thứ hai hoặc Thứ ba' ];
            return response()->json($response, 430);
        }
        else{
            if(Carbon::parse($date_start)->format('D') == 'Mon'){
                $scheduleS = '1';
            }
            else{
                $scheduleS = '2';
            }
            // return response()->json($schedule, 430);
        }


        $newRoom = new room;
        $newRoom->room_name = $room_name;
        $newRoom->max_mem = $max_mem;
        // $newRoom->date_start = Carbon::now()->setTimezone('+7')->format('D Y-m-d');
        $newRoom->date_start = $date_start;
        $newRoom->date_start = Carbon::parse($date_start)->format('Y-m-d');
        $newRoom->time_start = $time_start;
        $newRoom->time_end = $time_end;
        $newRoom->account_id = $account_id;
        $newRoom->course_id = $course_id;
        $newRoom->classroom_id = $classroom_id;
        $newRoom->scheduleS = $scheduleS;
        $newRoom->members = 0;
        // $newRoom->schedule = '1';

        // $response = [ 'message ' => 'Sai đụ mẹ' ];
        // return response()->json($response);
        $newRoom->save();



        //-------Thêm lịch học
        $course = course::where('course_id', $course_id)->first();

        $lessons = $course->lessons;

        if($lessons == 24){
            $days = 55;
        }
        else{
            if($lessons == 30){
                $days = 69;
            }
        }

        // return response()->json($days, 430);
        // $date = Carbon::parse($date_start)->format('Y-m-d');
        $date = $date_start;
        // $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));
        // return response()->json($date, 430);

        if($scheduleS == '1'){
            for($i = 1; $i <= $days; $i++){
                if(
                    (Carbon::parse($date)->format('D') == 'Mon')
                    ||(Carbon::parse($date)->format('D') == 'Wed')
                    ||(Carbon::parse($date)->format('D') == 'Fri')
                ){
                    $newSche = new schedule;
                    $newSche->room_id = $newRoom->room_id;
                    $newSche->date = Carbon::parse($date)->format('Y-m-d');
                    $newSche->save();  
                }
                $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));

            }                
        }
        else{
            if($scheduleS == '2'){
                for($i = 1; $i <= $days; $i++){
                    if(
                        (Carbon::parse($date)->format('D') == 'Tue')
                        ||(Carbon::parse($date)->format('D') == 'Thu')
                        ||(Carbon::parse($date)->format('D') == 'Sat')
                    ){
                        $newSche = new schedule;
                        $newSche->room_id = $newRoom->room_id;
                        $newSche->date = Carbon::parse($date)->format('Y-m-d');
                        $newSche->save();
                    }
                    $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));
    
                }                
            }

        }
        
        // return response()->json($date, 430);

        return response()->json($response, 200);
    }

    //Xóa khóa học
    public function deleteroomS(Request $req){
        $response = [ 'message' => 'Đã xóa khóa học'];

        $id = $req->room_id;

        $room = room::where('room_id',$id)->first();
        if($room == NULL){
            $response = ['message' => 'Không tìm thấy khóa học'];
            return response()->json($response, 430);
        }

        $room->delete();
        return response()->json($response, 200);
    }


    //LỊCH TẠM
    //Thêm lịch tạm
    public function addScheTemp(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'date_start' => 'required|date_format:D Y-m-d',
            'course_id' =>'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $date_start = $req->date_start;
        $course_id = $req->course_id;

        if((Carbon::parse($date_start)->format('D') != 'Mon') && (Carbon::parse($date_start)->format('D') != 'Tue')){
            $response = [ 'message ' => 'Buổi học đầu phải là Thứ hai hoặc Thứ ba' ];
            return response()->json($response, 430);
        }
        else{
            if(Carbon::parse($date_start)->format('D') == 'Mon'){
                $scheduleS = '1';
            }
            else{
                $scheduleS = '2';
            }
        }

            $course = course::where('course_id', $course_id)->first();

        $lessons = $course->lessons;

        if($lessons == 24){
            $days = 55;
        }
        else{
            if($lessons == 30){
                $days = 69;
            }
        }

        $date = $date_start;

        if($scheduleS == '1'){
            for($i = 1; $i <= $days; $i++){
                if(
                    (Carbon::parse($date)->format('D') == 'Mon')
                    ||(Carbon::parse($date)->format('D') == 'Wed')
                    ||(Carbon::parse($date)->format('D') == 'Fri')
                ){
                    $newSche = new schedule_temp;
                    // $newSche->room_id = $newRoom->room_id;
                    $newSche->date = Carbon::parse($date)->format('Y-m-d');
                    $newSche->save();  
                }
                $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));

            }                
        }
        else{
            if($scheduleS == '2'){
                for($i = 1; $i <= $days; $i++){
                    if(
                        (Carbon::parse($date)->format('D') == 'Tue')
                        ||(Carbon::parse($date)->format('D') == 'Thu')
                        ||(Carbon::parse($date)->format('D') == 'Sat')
                    ){
                        $newSche = new schedule_temp;
                        // $newSche->room_id = $newRoom->room_id;
                        $newSche->date = Carbon::parse($date)->format('Y-m-d');
                        $newSche->save();
                    }
                    $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));
    
                }                
            }

        }

        
        return response()->json($response, 200);
        

        
    }

    //Xóa lịch tạm
    public function deleteScheTemp(){
        $response = [ 'message' => 'Đã xóalịch tạm'];

        // $sche = schedule_temp::get();
        // $sche->delete();
        schedule_temp::query()->delete();

        return response()->json($response, 200);
    }

    //--------------------------------Lấy phòng trống-----------------------------------
    public function showclassrooms(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'date_start' => 'required|date_format:D Y-m-d',
            'time_start' => 'required',
            'time_end' => 'required|after:time_start',
            'course_id' =>'required|integer',
            'max_mem' =>'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $date_start = $req->date_start;
        $time_start = $req->time_start;
        $time_end = $req->time_end;
        $course_id = $req->course_id;

        if((Carbon::parse($date_start)->format('D') != 'Mon') && (Carbon::parse($date_start)->format('D') != 'Tue')){
            $response = [ 'message ' => 'Buổi học đầu phải là Thứ hai hoặc Thứ ba' ];
            return response()->json($response, 430);
        }
        else{
            if(Carbon::parse($date_start)->format('D') == 'Mon'){
                $scheduleS = '1';
            }
            else{
                $scheduleS = '2';
            }
        }

            $course = course::where('course_id', $course_id)->first();

        $lessons = $course->lessons;

        if($lessons == 24){
            $days = 55;
        }
        else{
            if($lessons == 30){
                $days = 69;
            }
        }

        $date = $date_start;

        if($scheduleS == '1'){
            for($i = 1; $i <= $days; $i++){
                if(
                    (Carbon::parse($date)->format('D') == 'Mon')
                    ||(Carbon::parse($date)->format('D') == 'Wed')
                    ||(Carbon::parse($date)->format('D') == 'Fri')
                ){
                    $newSche = new schedule_temp;
                    $newSche->date = Carbon::parse($date)->format('Y-m-d');
                    $newSche->save();  
                }
                $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));

            }                
        }
        else{
            if($scheduleS == '2'){
                for($i = 1; $i <= $days; $i++){
                    if(
                        (Carbon::parse($date)->format('D') == 'Tue')
                        ||(Carbon::parse($date)->format('D') == 'Thu')
                        ||(Carbon::parse($date)->format('D') == 'Sat')
                    ){
                        $newSche = new schedule_temp;
                        $newSche->date = Carbon::parse($date)->format('Y-m-d');
                        $newSche->save();
                    }
                    $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));
    
                }                
            }

        }

        $schedule_temp = schedule_temp::get();
        $schedule = schedule::get();

        $rooms = room::with('schedule')->get();
        // $rooms_sche = $rooms->schedule;
        

        $classroom_ids =[];


        foreach($rooms as $item1){
            foreach($item1->schedule as $item2){
                foreach($schedule_temp as $item3){
                    if($item2->date == $item3->date){
                        // return response()->json($item1->time_start, 430);
                        // if(($time_end->lt($item1->time_start))||($time_start->gt($item1->time_end))){
                        if((strtotime($time_end) < strtotime($item1->time_start))||(strtotime($time_start)> strtotime($item1->time_end))){
                            // $response = [ 'message ' => 'Tới đây là đúng' ];
                            // return response()->json($response, 430);

                        }
                        else{
                            // return response()->json($item1->classroom_id, 430);
                            $classroom_ids = array_merge($classroom_ids, [$item1->classroom_id]);
                        }
                    }
                }
            }
        }

        $max_mem = $req->max_mem;
        $classrooms = class_room::get();
        foreach($classrooms as $item4){
            if($item4->capacity < $max_mem){
                $classroom_ids = array_merge($classroom_ids, [$item4->classroom_id]);
            }
        }

        schedule_temp::query()->delete();


        return class_room::whereNotIn('classroom_id', $classroom_ids)->get();


        // $ids = [];   
        // $ids = array_merge($ids, [1]);
        // $ids = array_merge($ids, [2]);
        // $class = room::whereIn('room_id', $ids)->get();
        // return $class;
        // return 1;
    }


    //--------------------------------Lấy giáo viên trống lịch-----------------------------------
    public function showteachers(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'date_start' => 'required|date_format:D Y-m-d',
            'time_start' => 'required',
            'time_end' => 'required|after:time_start',
            'course_id' =>'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $date_start = $req->date_start;
        $time_start = $req->time_start;
        $time_end = $req->time_end;
        $course_id = $req->course_id;

        if((Carbon::parse($date_start)->format('D') != 'Mon') && (Carbon::parse($date_start)->format('D') != 'Tue')){
            $response = [ 'message ' => 'Buổi học đầu phải là Thứ hai hoặc Thứ ba' ];
            return response()->json($response, 430);
        }
        else{
            if(Carbon::parse($date_start)->format('D') == 'Mon'){
                $scheduleS = '1';
            }
            else{
                $scheduleS = '2';
            }
        }

            $course = course::where('course_id', $course_id)->first();

        $lessons = $course->lessons;

        if($lessons == 24){
            $days = 55;
        }
        else{
            if($lessons == 30){
                $days = 69;
            }
        }

        $date = $date_start;

        if($scheduleS == '1'){
            for($i = 1; $i <= $days; $i++){
                if(
                    (Carbon::parse($date)->format('D') == 'Mon')
                    ||(Carbon::parse($date)->format('D') == 'Wed')
                    ||(Carbon::parse($date)->format('D') == 'Fri')
                ){
                    $newSche = new schedule_temp;
                    $newSche->date = Carbon::parse($date)->format('Y-m-d');
                    $newSche->save();  
                }
                $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));

            }                
        }
        else{
            if($scheduleS == '2'){
                for($i = 1; $i <= $days; $i++){
                    if(
                        (Carbon::parse($date)->format('D') == 'Tue')
                        ||(Carbon::parse($date)->format('D') == 'Thu')
                        ||(Carbon::parse($date)->format('D') == 'Sat')
                    ){
                        $newSche = new schedule_temp;
                        $newSche->date = Carbon::parse($date)->format('Y-m-d');
                        $newSche->save();
                    }
                    $date = date('D Y-m-d', strtotime('+1 day', strtotime($date)));
    
                }                
            }

        }

        $schedule_temp = schedule_temp::get();
        $schedule = schedule::get();

        $rooms = room::with('schedule')->get();
        // $rooms_sche = $rooms->schedule;
        

        $teacher_ids =[];


        foreach($rooms as $item1){
            foreach($item1->schedule as $item2){
                foreach($schedule_temp as $item3){
                    if($item2->date == $item3->date){
                        // return response()->json($item1->time_start, 430);
                        // if(($time_end->lt($item1->time_start))||($time_start->gt($item1->time_end))){
                        if((strtotime($time_end) < strtotime($item1->time_start))||(strtotime($time_start)> strtotime($item1->time_end))){
                            // $response = [ 'message ' => 'Tới đây là đúng' ];
                            // return response()->json($response, 430);

                        }
                        else{
                            // return response()->json($item1->classroom_id, 430);
                            $teacher_ids = array_merge($teacher_ids, [$item1->account_id]);
                        }
                    }
                }
            }
        }

        schedule_temp::query()->delete();


        return user_account::where('name', 'LIKE', '%'.$req->search_name.'%')->where('type', 2)->whereNotIn('account_id', $teacher_ids)->get();


        // $ids = [];   
        // $ids = array_merge($ids, [1]);
        // $ids = array_merge($ids, [2]);
        // $class = room::whereIn('room_id', $ids)->get();
        // return $class;
        // return 1;
    }

    



    //-------------------------------------------------------------------//



    //---------VỚI LỚP HỌC---------
    //Thêm mới lớp học
    public function newroom(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'room_name' =>'required',
            'account_id' => 'required|integer',
            'date_start' => 'required|date',
            'date_end' => 'required|date'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $room_name = $req->room_name;
        $schedule = $req->schedule;
        $date_start = $req->date_start;
        $date_end = $req->date_end;
        $account_id = $req->account_id;

        // if(room::where('room_name', $room_name)->exists()){
        //     $response = ['message' => 'Đã có thông tin khóa học này rồi'];
        //     return response()->json($response, 430);
        // }

        $newRoom = new room;
        $newRoom->room_name = $room_name;
        $newRoom->schedule = $schedule;
        $newRoom->date_start = $date_start;
        $newRoom->date_end = $date_end;
        $newRoom->account_id = $account_id;
        $newRoom->save();

        return response()->json($response, 200);
    }


    //Xóa khóa học
    public function deleteroom(Request $req){
        $response = [ 'message' => 'Đã xóa khóa học'];

        $id = $req->room_id;

        $room = room::where('room_id',$id)->first();
        if($room == NULL){
            $response = ['message' => 'Không tìm thấy khóa học'];
            return response()->json($response, 430);
        }

        $room->delete();
        return response()->json($response, 200);
    }


    //sửa khóa học
    public function editroom(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'room_name' =>'required',
            'account_id' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $room_id = $req->room_id;
        $room_name = $req->room_name;
        $schedule = $req->schedule;
        $date_start = $req->date_start;
        $date_end = $req->date_end;
        $account_id = $req->account_id;


        $room = room::where('room_id',$room_id)->first();
        if($room == NULL){
            $response = ['message' => 'Không tìm thấy khóa học'];
            return response()->json($response, 430);
        }

        $room->room_name = $room_name;
        $room->schedule = $schedule;
        $room->date_start = $date_start;
        $room->date_end = $date_end;
        $room->account_id = $account_id;
        $room->save();

        return response()->json($response, 200);
    }


    //---------VỚI HỌC VIÊN CỦA MỖI LỚP HỌC---------
    //Thêm học viên vào khóa học
    public function addstudent(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'room_id' =>'required',
            'account_id' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $room_id = $req->room_id;
        $account_id = $req->account_id;

        $room = room::where('room_id', $room_id)->first();

        // if(registration::where('room_id', $room_id)){
        //     if(registration::where('account_id', $account_id)->exists()){
        //         $response = ['message' => 'Tài khoản đã được đăng ký trong khóa học'];
        //         return response()->json($response, 430);
        //     }
        // }

        if($room->max_mem > $room->members){
            if(registration::where('room_id', $room_id)->where('account_id', $account_id)->exists()){
                $response = ['message' => 'Tài khoản đã được đăng ký trong khóa học'];
                return response()->json($response, 430);
            }
    
            $newRegist = new registration;
            $newRegist->account_id = $account_id;
            $newRegist->room_id = $room_id;
            $newRegist->save();

            $room->members = $room->members+1;
            $room->save();
    
            return response()->json($response, 200);
            
        }
        else{  
            $response = ['message' => 'Lớp học đã đủ chỗ'];
            return response()->json($response, 430);

        }

        
    }


    //Xóa học viên khỏi khóa học
    public function removestudent(Request $req){
        $response = [ 'message' => 'Đã xóa học viên khỏi khóa học'];

        $id = $req->register_id;

        $regist = registration::where('register_id',$id)->first();
        if($regist == NULL){
            $response = ['message' => 'Không tìm thấy thông tin đăng ký'];
            return response()->json($response, 430);
        }

        $regist->delete();
        return response()->json($response, 200);
    }


    
}
