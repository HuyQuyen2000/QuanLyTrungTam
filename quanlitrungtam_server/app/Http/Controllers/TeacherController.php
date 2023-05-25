<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\user_account;
use App\Models\room;
use App\Models\registration;
use App\Models\post;
use App\Models\comment;
use App\Models\submition;
use App\Models\task;
use App\Models\language;
use App\Models\course;
use App\Models\schedule_temp;

class TeacherController extends Controller
{
    //--------------VỀ BÀI VIẾT-------------
    //Tạo bài viết
    public function newpost(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'post_type' =>'required|integer',
            'content' =>'required',
            'room_id' =>'required|integer',
            'account_id' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin hãy nhập nội dung bài viết' ];
            return response()->json($response, 430);
        }

        $post_type = $req->post_type;
        $content = $req->content;
        $time = Carbon::now()->setTimezone('+7');
        $room_id = $req->room_id;
        $account_id = $req->account_id;
        
        
        $newPost = new post;
        $newPost->post_type = $post_type;
        $newPost->content = $content;
        $newPost->time = $time->format('Y-m-d H:i:s');
        $newPost->room_id = $room_id;
        $newPost->account_id = $account_id;
        $newPost->save();

        return response()->json($response, 200);
    }


    //Xóa bài viết
    public function deletepost(Request $req){
        $response = [ 'message' => 'Xóa bài viết thành công'];

        $id = $req->post_id;

        $post = post::where('post_id',$id)->first();
        if($post == NULL){
            $response = ['message' => 'Không tìm thấy bài viết'];
            return response()->json($response, 430);
        }

        $post->delete();
        return response()->json($response, 200);
    }


    //Sửa bài viết
    public function editpost(Request $req){
        $response = [ 'message' => 'Đã sửa bài viết'];
        $rules = [
            'content' =>'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập nội dung bài viết' ];
            return response()->json($response, 430);
        }

        $post_id = $req->post_id;
        $content = $req->content;


        $post = post::where('post_id',$post_id)->first();
        if($post == NULL){
            $response = ['message' => 'Không tìm thấy bài viết'];
            return response()->json($response, 430);
        }

        $post->content = $content;
        $post->save();

        return response()->json($response, 200);
    }


    //--------------VỀ BÌNH LUẬN-------------
    //Thêm bình luận
    public function newcomment(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'content' =>'required',
            'post_id' =>'required|integer',
            'account_id' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập nội dung bình luận' ];
            return response()->json($response, 430);
        }

        $content = $req->content;
        $com_time = Carbon::now()->setTimezone('+7');
        $post_id = $req->post_id;
        $account_id = $req->account_id;
        
        
        $newComment = new comment;
        $newComment->content = $content;
        $newComment->com_time = $com_time->format('Y-m-d H:i:s');
        $newComment->post_id = $post_id;
        $newComment->account_id = $account_id;
        $newComment->save();

        return response()->json($response, 200);
    }

    //Xóa bình luận
    public function deletecomment(Request $req){
        $response = [ 'message' => 'Đã xóa bình luận'];

        $id = $req->comment_id;

        $comment = comment::where('comment_id',$id)->first();
        if($comment == NULL){
            $response = ['message' => 'Không tìm thấy bình luận'];
            return response()->json($response, 430);
        }

        $comment->delete();
        return response()->json($response, 200);
    }


    //Sửa bình luận
    public function editcomment(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'content' =>'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $comment_id = $req->comment_id;
        $content = $req->content;


        $comment = comment::where('comment_id',$comment_id)->first();
        if($comment == NULL){
            $response = ['message' => 'Không tìm thấy bình luận'];
            return response()->json($response, 430);
        }

        $comment->content = $content;
        $comment->save();

        return response()->json($response, 200);
    }


    public function updateSubmitList(Request $req){
        $response = [ 'message' => 'Đã cập nhật danh sách'];
        // $rules = [
        //     'content' =>'required',
        // ];
        // $validator = Validator::make($req->all(), $rules);
        // if($validator->fails()){
        //     $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
        //     return response()->json($response, 430);
        // }

        $room_id = $req->room_id;
        $task_id = $req->task_id;

        $register = registration::where('room_id', $room_id)->get();
        
        foreach($register as $item1){
            if($submit = submition::where(['task_id'=> $task_id, 'account_id' => $item1->account_id,])->exists()){

            }
            else{
                $newSubmit = new submition;
                $newSubmit->task_id = $req->task_id;
                $newSubmit->account_id = $item1->account_id;
                $newSubmit->status = 1;
                $newSubmit->save();
            }
        }

        return response()->json($response, 200);
    }

}
