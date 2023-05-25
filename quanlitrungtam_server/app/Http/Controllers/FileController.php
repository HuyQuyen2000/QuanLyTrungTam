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
use App\Models\document;
use App\Models\task;
use App\Models\submition;
use App\Models\language;
use App\Models\course;

use Pion\Laravel\ChunkUpload\Exceptions\UploadMissingFileException;
use Pion\Laravel\ChunkUpload\Handler\AbstractHandler;
use Pion\Laravel\ChunkUpload\Handler\HandlerFactory;
use Pion\Laravel\ChunkUpload\Receiver\FileReceiver;
use Illuminate\Http\UploadedFile;
use Illuminate\Http\Response;
use File;
// use Storage;
use Illuminate\Support\Facades\Storage;


class FileController extends Controller
{
    //
    public function file_upload(Request $request)
    {   
        $validator = \Validator::make($request->all(), [

            'file' => 'required|mimes:jpg,png,doc,docx,pdf,xls,xlsx,zip,m4v,avi,flv,mp4,mov',

        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'message' => $validator->errors()->first()]);
        }

        $receiver = new FileReceiver('file', $request, HandlerFactory::classFromRequest($request));
        if ($receiver->isUploaded() === false) {
            throw new UploadMissingFileException();
        }
        $save = $receiver->receive();
        if ($save->isFinished()) {
            $response =  $this->saveFile($save->getFile());

            File::deleteDirectory(storage_path('app/chunks/'));

            //your data insert code

            return response()->json([
                'status' => true,
                'link' => url($response['link']),
                'message' => 'File successfully uploaded.'
            ]);
        }
        $handler = $save->handler();
    }

    /**
     * Saves the file
     *
     * @param UploadedFile $file
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function saveFile(UploadedFile $file)
    {
        $fileName = $this->createFilename($file);
        $mime = str_replace('/', '-', $file->getMimeType());
        $filePath = "public/document/";
        $file->move(base_path($filePath), $fileName);

        return [
            'link' => $filePath . $fileName,
            'mime_type' => $mime
        ];
    }
    /**
     * Create unique filename for uploaded file
     * @param UploadedFile $file
     * @return string
     */
    protected function createFilename(UploadedFile $file)
    {
        $extension = $file->getClientOriginalExtension();
        $filename =  rand() . time() . "." . $extension;
        return $filename;
    }


    //Lấy file
    public function getFile(){
        // $file = File::get(storage_path('public\document\15920135171681994129.pdf'));
        // $file = Storage::disk('public')->get('document/15920135171681994129.pdf');
        // $file = Storage::get('15920135171681994129.pdf');
        // if(Storage::exists('public/document/15920135171681994129.pdf')){
        //     $file = Storage::get('public/document/15920135171681994129.pdf');
        //     $content = file_get_contents($file);
        //     return response($content)->withHeaders([
        //         'Content-Type'=>mime_content_type($file)
        //     ]); 

        // }
        // else{
        //     return response('Sai rồi đụ mẹ mày');

        // }
        // return redirect('/404');

        
        // $file = Storage::response('15920135171681994129.pdf');
        return response()->file('C:\xampp\htdocs\quanlitrungtam\public\document\15920135171681994129.pdf');
        // return Storage::response('15920135171681994129.pdf');
        // return response(file(storage_path('C:/xampp/htdocs/quanlitrungtam/public/document/15920135171681994129.pdf')));
        
        
        // return $file;
        // return response()->file('public\document\15920135171681994129.pdf');
    }




    //GIÁO VIÊN UPLOAD TÀI LIỆU
    public function file_uploadTeacher(Request $request)
    {   
        $validator = \Validator::make($request->all(), [

            'file' => 'required|mimes:jpg,png,doc,docx,pdf,xls,xlsx,zip,m4v,avi,flv,mp4,mov',
            'post_type' =>'required',
            'content' =>'required',
            'room_id' =>'required',
            'account_id' => 'required',

        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'Xin hãy thêm nội dung' => $validator->errors()->first()]);
        }

        $post_type = $request->post_type;
        $content = $request->content;
        $time = Carbon::now()->setTimezone('+7');
        $room_id = $request->room_id;
        $account_id = $request->account_id;

        $newPost = new post;
        $newPost->post_type = $post_type;
        $newPost->content = $content;
        $newPost->time = $time->format('Y-m-d H:i:s');
        $newPost->room_id = $room_id;
        $newPost->account_id = $account_id;
        $newPost->save();

        $newDocument = new document;
        $newDocument->post_id = $newPost->post_id;
        $newDocument->save();


        $receiver = new FileReceiver('file', $request, HandlerFactory::classFromRequest($request));
        if ($receiver->isUploaded() === false) {
            throw new UploadMissingFileException();
        }
        $save = $receiver->receive();
        if ($save->isFinished()) {
            $response =  $this->saveFileTeacher($save->getFile(), $newDocument);

            File::deleteDirectory(storage_path('app/chunks/'));

            //your data insert code

            return response()->json([
                'status' => true,
                'link' => url($response['link']),
                'message' => 'File successfully uploaded.'
            ]);
        }
        $handler = $save->handler();

        // return response()->json($response, 200);
    }

    /**
     * Saves the file
     *
     * @param UploadedFile $file
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function saveFileTeacher(UploadedFile $file, document $newDocument)
    {
        $fileName = $this->createFilenameTeacher($file);
        $mime = str_replace('/', '-', $file->getMimeType());
        $filePath = "public/document/";
        $file->move(base_path($filePath), $fileName);

        $newDocument->document_name =  $fileName;
        $newDocument->save();

        return [
            'link' => $filePath . $fileName,
            'mime_type' => $mime
        ];
    }
    /**
     * Create unique filename for uploaded file
     * @param UploadedFile $file
     * @return string
     */
    protected function createFilenameTeacher(UploadedFile $file)
    {
        $extension = $file->getClientOriginalExtension();
        $filename =  rand() . time() . "." . $extension;
        return $filename;
    }


    //Lấy file
    public function getFileTeacher(Request $req){
        $doc_name = $req->doc_name;
        // $file_name = document::where('post_id',$post_id)->first();
        $path = 'C:/xampp/htdocs/quanlitrungtam/public/document/';
        $file_name = '15920135171681994129.pdf';
        $file = $path.$doc_name;

        return response()->file($file);
    }

    public function getFileTeacher2(Request $req){
        $post_id = $req->post_id;
        $file_name = document::where('post_id',$post_id)->first();
        $path = 'C:/xampp/htdocs/quanlitrungtam/public/document/';
        $file = $path.$file_name->doucment_name;

        // $file = Storage::get('document/'+ $file_name->document_name);

        // return response()->file('C:\xampp\htdocs\quanlitrungtam\public\document'+ $file_name);
        // return response()->file('C:\xampp\htdocs\quanlitrungtam\public\document\15920135171681994129.pdf');
        // return response()->file($file);
        return response()->download($file);
        // return response()->file('C:/xampp/htdocs/quanlitrungtam/public/document/15920135171681994129.pdf');
        
    }


    //GIÁO VIÊN UPLOAD BÀI TẬP
    public function file_uploadTask(Request $request)
    {   
        $validator = \Validator::make($request->all(), [

            'file' => 'required|mimes:jpg,png,doc,docx,pdf,xls,xlsx,zip,m4v,avi,flv,mp4,mov',
            'post_type' =>'required',
            'content' =>'required',
            'room_id' =>'required',
            'account_id' => 'required',
            'deadline' => 'required',

        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'Xin hãy thêm nội dung và thời hạn' => $validator->errors()->first()]);
        }

        $post_type = $request->post_type;
        $content = $request->content;
        $time = Carbon::now()->setTimezone('+7');
        $room_id = $request->room_id;
        $account_id = $request->account_id;

        $newPost = new post;
        $newPost->post_type = $post_type;
        $newPost->content = $content;
        $newPost->time = $time->format('Y-m-d H:i:s');
        $newPost->room_id = $room_id;
        $newPost->account_id = $account_id;
        $newPost->save();

        $newTask = new task;
        $newTask->post_id = $newPost->post_id;
        $newTask->deadline = $request->deadline;
        $newTask->save();

        $register = registration::where('room_id',$request->room_id)->get();
        $count = registration::where('room_id',$request->room_id)->count();

        // $i = 0;
        foreach($register as $item){
            $newSubmit = new submition;
            $newSubmit->task_id = $newTask->task_id;
            $newSubmit->account_id = $item->account_id;
            $newSubmit->status = 1;
            $newSubmit->save();
            // $i++;
        }


        $receiver = new FileReceiver('file', $request, HandlerFactory::classFromRequest($request));
        if ($receiver->isUploaded() === false) {
            throw new UploadMissingFileException();
        }
        $save = $receiver->receive();
        if ($save->isFinished()) {
            $response =  $this->saveFileTask($save->getFile(), $newTask);

            File::deleteDirectory(storage_path('app/chunks/'));

            //your data insert code

            return response()->json([
                'status' => true,
                'link' => url($response['link']),
                'message' => 'File successfully uploaded.'
            ]);
        }
        $handler = $save->handler();


        


        

        // return response()->json($response, 200);
    }

    /**
     * Saves the file
     *
     * @param UploadedFile $file
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function saveFileTask(UploadedFile $file, task $newTask)
    {
        $fileName = $this->createFilenameTask($file);
        $mime = str_replace('/', '-', $file->getMimeType());
        $filePath = "public/document/";
        $file->move(base_path($filePath), $fileName);

        $newTask->document_name =  $fileName;
        $newTask->save();

        return [
            'link' => $filePath . $fileName,
            'mime_type' => $mime
        ];
    }
    /**
     * Create unique filename for uploaded file
     * @param UploadedFile $file
     * @return string
     */
    protected function createFilenameTask(UploadedFile $file)
    {
        $extension = $file->getClientOriginalExtension();
        $filename =  rand() . time() . "." . $extension;
        return $filename;
    }


    //Lấy file
    public function getFileTask(Request $req){
        $doc_name = $req->doc_name;
        // $file_name = document::where('post_id',$post_id)->first();
        $path = 'C:/xampp/htdocs/quanlitrungtam/public/document/';
        $file_name = '15920135171681994129.pdf';
        $file = $path.$doc_name;

        return response()->file($file);
    }



    //HỌC VIÊN NỘP BÀI
    public function submitTask(Request $request)
    {   
        $validator = \Validator::make($request->all(), [

            'file' => 'required|mimes:jpg,png,doc,docx,pdf,xls,xlsx,zip,m4v,avi,flv,mp4,mov',
            'submit_id' =>'required',

        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'Xin hãy chọn file đăng tải' => $validator->errors()->first()]);
        }

        $submit_id = $request->submit_id;
        $submit_time = Carbon::now()->setTimezone('+7');
        $status = 2;

        $submit = submition::where('submit_id', $submit_id)->first();
        $submit->submit_time = $submit_time;
        $submit->status = $status;
        $submit->save();


        $receiver = new FileReceiver('file', $request, HandlerFactory::classFromRequest($request));
        if ($receiver->isUploaded() === false) {
            throw new UploadMissingFileException();
        }
        $save = $receiver->receive();
        if ($save->isFinished()) {
            $response =  $this->saveSubmitTask($save->getFile(), $submit);

            File::deleteDirectory(storage_path('app/chunks/'));

            //your data insert code

            return response()->json([
                'status' => true,
                'link' => url($response['link']),
                'message' => 'File successfully uploaded.'
            ]);
        }
        $handler = $save->handler();
  

        // return response()->json($response, 200);
    }

    /**
     * Saves the file
     *
     * @param UploadedFile $file
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function saveSubmitTask(UploadedFile $file, submition $submit)
    {
        $fileName = $this->createSubmitnameTask($file);
        $mime = str_replace('/', '-', $file->getMimeType());
        $filePath = "public/document/";
        $file->move(base_path($filePath), $fileName);

        $submit->document_name =  $fileName;
        $submit->save();

        return [
            'link' => $filePath . $fileName,
            'mime_type' => $mime
        ];
    }
    /**
     * Create unique filename for uploaded file
     * @param UploadedFile $file
     * @return string
     */
    protected function createSubmitnameTask(UploadedFile $file)
    {
        $extension = $file->getClientOriginalExtension();
        $filename =  rand() . time() . "." . $extension;
        return $filename;
    }



    



    

}
