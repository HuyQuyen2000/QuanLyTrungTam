<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\user_account;
use App\Models\room;
use App\Models\registration;
use App\Models\post;
use App\Models\comment;
use App\Models\document;
use App\Models\task;
use App\Models\submition;
use App\Models\language;
use App\Models\course;
use App\Models\class_room;
use App\Models\schedule;

class ListController extends Controller
{
    //LẤY TẤT CẢ TÀI KHOẢN
    public function allaccounts(){
        return user_account::get()->sortBy('account_id');
        // return 1;
    }

    //LẤY TẤT CẢ NGÔN NGỮ
    public function alllanguages(){
        return language::get()->sortBy('language_id');
        // return 1;
    }

    //LẤY TẤT CẢ KHÓA HỌC
    public function allcourses(){
        return course::with('language')->get()->sortBy('course_id');
        // return 1;
    }

    //LẤY TẤT CẢ KHÓA HỌC THEO NGÔN NGỮ
    public function languagecourses(Request $req){
        $language_id = $req->language_id;
        
        if($language_id == 0){
            return course::with('language')->get()->sortBy('course_id');
        }
        else{
            return course::where('language_id', $language_id)->with('language')->get()->sortBy('course_id');
        }    
    }

    public function languagecourses2(Request $req){
        $language_id = $req->language_id;
        
        if($language_id == 0){
            return course::with('language')->get()->sortBy('course_id');
        }
        else{
            return course::where('language_id', $language_id)->with('language')->get()->sortBy('course_id');
        }    
    }

    //LẤY KHÓA HỌC THEO ID
    public function idcourse(Request $req){
        $course_id = $req->course_id;
        $course = course::with('language')->where('course_id', $course_id)->first();
        return $course;
    }

    //LẤY TÀI KHOẢN THEO ID
    public function idaccount(Request $req){
        $account_id = $req->account_id;
        $user = user_account::where('account_id',$account_id)->first();
        return $user;
    }

    //LẤY TÀI KHOẢN THEO LOẠI
    public function alltypeaccounts(Request $req){
        $type = $req->type;
        $search_name = $req->search_name;
        // $user = user_account::where('name', 'LIKE', '%'.$search_name.'%');
        if($type == 0){
            $user = user_account::where('name', 'LIKE', '%'.$search_name.'%')->get()->sortBy('account_id');
        }

        if($type != 0){
            $user = user_account::where('name', 'LIKE', '%'.$search_name.'%')->where('type',$type)->get()->sortBy('account_id');
        }

        return $user;
    }

    //LẤY TẤT CẢ PHÒNG
    public function allclassrooms(){
        return class_room::get()->sortBy('classroom_id');
        // return 1;
    }
    

    //LẤY TẤT CẢ KHÓA HỌC
    public function allrooms(){
        $rooms = room::with('teacher')->orderBy('room_id','desc')->get();
        return $rooms;
    }

    //LẤY TẤT CẢ LỚP HỌC "MỚI"
    public function allroomsS(){
        $rooms = room::with('teacher', 'course', 'class_room')->orderBy('room_id','desc')->get();
        return $rooms;
    }

    //LẤY LỚP HỌC "MỚI" THEO NGÔN NGỮ VÀ KHÓA HỌC
    public function alltyperoomsS(Request $req){
        $search_name = $req->search_name;
        if(($req->language_id == 0)&&($req->course_id == 0)){
            $rooms = room::where('room_name', 'LIKE', '%'.$search_name.'%')->with('teacher', 'course', 'class_room')->orderBy('room_id','desc')->get();
        }
        else{
            if(($req->language_id != 0)&&($req->course_id == 0)){
                // $rooms = room::with('teacher', 'course', 'class_room')
                // ->whereHas('course', function(Builder $query){
                //     $query->where('language_id', $req->language_id);
                // })
                // ->orderBy('room_id','desc')->get();
                $rooms = room::where('room_name', 'LIKE', '%'.$search_name.'%')->with('teacher', 'course', 'class_room')
                ->whereHas('course', function($query) use($req){
                    $query->where('language_id', $req->language_id);
                })
                ->orderBy('room_id','desc')->get();
            }
            else{
                if(($req->language_id != 0)&&($req->course_id != 0)){
                    $rooms = room::where('room_name', 'LIKE', '%'.$search_name.'%')->where( 'course_id', $req->course_id)->with('teacher', 'course', 'class_room')->orderBy('room_id','desc')->get();
                }
            }

        }
        return $rooms;
    }

    //LẤY KHÓA HỌC THEO ID
    public function idroom(Request $req){
        $room_id = $req->room_id;
        $room = room::with('teacher','course','class_room','course.language')->where('room_id',$room_id)->first();
        return $room;
    }

    //KHÓA HỌC GIÁO VIÊN ĐƯỢC PHÂN CÔNG
    public function teacherrooms(Request $req){
        $account_id = $req->account_id;
        $rooms = room::where('account_id',$account_id)->orderBy('room_id','desc')->get();
        return $rooms;
    }

    //KHÓA HỌC ĐÃ ĐĂNG KÝ
    public function studentrooms(Request $req){
        $account_id = $req->account_id;
        $regist = registration::where('account_id',$account_id)->with('room', 'room.teacher')->orderBy('register_id','desc')->get();
        return $regist;
    }

    //LẤY DANH SÁCH HỌC SINH CHƯA ĐĂNG KÝ KHÓA HỌC
    public function studentSpe(Request $req){
        $type = '3';
        return user_account::where('type',$type)->get()->sortBy('account_id');
    }

    //LẤY DANH SÁCH HỌC VIÊN CỦA MỘT LỚP HỌC
    public function studentlist(Request $req){
        $room_id = $req->room_id;
        $regist = registration::where('room_id',$room_id)->with('student')->get()->sortBy('register_id');
        return $regist;
    }

    //LẤY DANH SÁCH CÁC BÀI VIẾT TRONG MỘT LỚP HỌC
    public function postlist(Request $req){
        $room_id = $req->room_id;
        $post = post::where('room_id',$room_id)->with('teacher')->orderBy('post_id','desc')->get();
        return $post;
    }

    //LẤY DANH SÁCH CÁC BÀI VIẾT LÀ THÔNG BÁO TRONG MỘT LỚP HỌC
    public function post1list(Request $req){
        $room_id = $req->room_id;
        $post = post::where(['room_id' => $room_id, 'post_type' => 1])->with('teacher')->orderBy('post_id','desc')->get();
        return $post;
    }

    public function post2list(Request $req){
        $room_id = $req->room_id;
        $post = post::where(['room_id' => $room_id, 'post_type' => 2])->with('teacher')->orderBy('post_id','desc')->get();
        return $post;
    }

    public function post3list(Request $req){
        $room_id = $req->room_id;
        $post = post::where(['room_id' => $room_id, 'post_type' => 3])->with('teacher')->orderBy('post_id','desc')->get();
        return $post;
    }

    //LẤY BÀI VIẾT THEO ID
    public function idpost(Request $req){
        $post_id = $req->post_id;
        $post = post::with('teacher')->where('post_id',$post_id)->first();
        return $post;
    }

    //LẤY DANH SÁCH CÁC BÌNH LUÂN TRONG MỘT BÀI VIẾT
    public function commentlist(Request $req){
        $post_id = $req->post_id;
        $comment = comment::where('post_id',$post_id)->with('user_account')->orderBy('comment_id','desc')->get();
        return $comment;
    }

    //LẤY DANH SÁCH NỘP BÀI
    public function submitlist(Request $req){
        $task_id = $req->task_id;
        $submit = submition::where('task_id',$task_id)->with('user_account')->get();
        return $submit;
    }


    //LẤY THÔNG TIN TÀI LIỆU
    public function iddocument(Request $req){
        $post_id = $req->post_id;
        $document = document::where('post_id',$post_id)->first();
        return $document;
    }

    //LẤY THÔNG TIN BÀI TẬP
    public function idtask(Request $req){
        $post_id = $req->post_id;
        $document = task::where('post_id',$post_id)->first();
        return $document;
    }

    //LẤY THÔNG TIN NỘP BÀI
    public function submitInfor(Request $req){
        $task_id = $req->task_id;
        $account_id = $req->account_id;

        $submit = submition::where(['task_id' => $task_id, 'account_id' => $account_id])->first();
        return $submit;
    }

    //LẤY THÔNG TIN NỘP BÀI THEO ID
    public function idsubmit(Request $req){
        $submit_id = $req->submit_id;

        $submit = submition::where('submit_id', $submit_id)->first();
        return $submit;
    }


    //LẤY LỊCH CÁC KHÓA HỌC CỦA GIÁO VIÊN
    public function listScheduleTeacher(Request $req){
        $schedule = schedule::with('room','room.class_room')
        ->whereHas('room', function($query) use($req){
            $query->where('account_id', $req->account_id);
        })
        ->get();

        return $schedule;
    }

    //LẤY LỊCH CÁC KHÓA HỌC CỦA GIÁO VIÊN THEO NGÀY
    public function listScheduleTeacherDay(Request $req){
        $schedule = schedule::with('room')->where('date', $req->date)
        ->whereHas('room', function($query) use($req){
            $query->where('account_id', $req->account_id);
        })
        ->get();

        return $schedule;

    }

    //LẤY LỊCH CÁC KHÓA HỌC CỦA HỌC VIÊN
    public function listScheduleStudent(Request $req){
        $schedule = schedule::with('room','room.class_room')
        ->whereHas('room', function($query) use($req){
            $query->whereHas('registration',function($query1) use($req){
                $query1->where('account_id',$req->account_id);
            });
        })
        ->get();

        return $schedule;
    }


    //LẤY LỊCH HỌC THEO LỚP
    public function listScheduleRoom(Request $req){
        $schedule = schedule::with('room')->where('room_id', $req->room_id)->get();
        return $schedule;
    }


}
