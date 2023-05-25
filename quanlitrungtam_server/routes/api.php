<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ListController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\TeacherController;

use App\Http\Controllers\FileController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

//Tài khoản
Route::post('/login', [UserController::class, 'login']);
Route::post('/login2', [UserController::class, 'login2']);
Route::get('/testlogin', [UserController::class, 'testlogin']);
Route::get('/testlogin2', [UserController::class, 'testlogin2']);
Route::post('/logout', [UserController::class, 'logout']);


//Các liệt kê danh sách
Route::get('/allaccounts', [ListController::class, 'allaccounts']);
Route::get('/alltypeaccounts', [ListController::class, 'alltypeaccounts']);
Route::get('/alllanguages', [ListController::class, 'alllanguages']);
Route::get('/allcourses', [ListController::class, 'allcourses']);
Route::get('/languagecourses', [ListController::class, 'languagecourses']);
Route::get('/languagecourses2', [ListController::class, 'languagecourses2']);
Route::get('/allclassrooms', [ListController::class, 'allclassrooms']);
Route::get('/allrooms', [ListController::class, 'allrooms']);
Route::get('/allroomsS', [ListController::class, 'allroomsS']);
Route::get('/alltyperoomsS', [ListController::class, 'alltyperoomsS']);
Route::get('/studentlist', [ListController::class, 'studentlist']);
Route::get('/teacherrooms', [ListController::class, 'teacherrooms']);
Route::get('/studentrooms', [ListController::class, 'studentrooms']);
Route::get('/postlist', [ListController::class, 'postlist']);
Route::get('/post1list', [ListController::class, 'post1list']);
Route::get('/post2list', [ListController::class, 'post2list']);
Route::get('/post3list', [ListController::class, 'post3list']);
Route::get('/commentlist', [ListController::class, 'commentlist']);
Route::get('/submitlist', [ListController::class, 'submitlist']);

Route::get('/listScheduleTeacher', [ListController::class, 'listScheduleTeacher']);
Route::get('/listScheduleTeacherDay', [ListController::class, 'listScheduleTeacherDay']);
Route::get('/listScheduleStudent', [ListController::class, 'listScheduleStudent']);
Route::get('/listScheduleRoom', [ListController::class, 'listScheduleRoom']);

Route::get('/idaccount', [ListController::class, 'idaccount']);
Route::get('/idcourse', [ListController::class, 'idcourse']);
Route::get('/idroom', [ListController::class, 'idroom']);
Route::get('/idpost', [ListController::class, 'idpost']);
Route::get('/idsubmit', [ListController::class, 'idsubmit']);

Route::get('/iddocument', [ListController::class, 'iddocument']);
Route::get('/idtask', [ListController::class, 'idtask']);

Route::get('/submitInfor', [ListController::class, 'submitInfor']);

//Của Admin
Route::post('/newuser', [AdminController::class, 'newuser']);
Route::delete('/deleteuser', [AdminController::class, 'deleteuser']);
Route::patch('/edituser', [AdminController::class, 'edituser']);

Route::post('/newlanguage', [AdminController::class, 'newlanguage']);
Route::delete('/deletelanguage', [AdminController::class, 'deletelanguage']);

Route::post('/newcourse', [AdminController::class, 'newcourse']);
Route::delete('/deletecourse', [AdminController::class, 'deletecourse']);
Route::patch('/editcourse', [AdminController::class, 'editcourse']);


Route::post('/newroomS', [AdminController::class, 'newroomS']);
Route::delete('/deleteroomS', [AdminController::class, 'deleteroomS']);
// Route::patch('/editroom', [AdminController::class, 'editroom']);
Route::post('/addScheTemp', [AdminController::class, 'addScheTemp']);
Route::delete('/deleteScheTemp', [AdminController::class, 'deleteScheTemp']);
Route::get('/showclassrooms', [AdminController::class, 'showclassrooms']);
Route::get('/showteachers', [AdminController::class, 'showteachers']);

//
//----------------------------------------------------------------
Route::post('/newroom', [AdminController::class, 'newlanguage']);
Route::delete('/deleteroom', [AdminController::class, 'deleteroom']);
Route::patch('/editroom', [AdminController::class, 'editroom']);
//----------------------------------------------------------------
//

Route::post('/addstudent', [AdminController::class, 'addstudent']);
Route::delete('/removestudent', [AdminController::class, 'removestudent']);


//Của Teacher
Route::post('/newpost', [TeacherController::class, 'newpost']);
Route::delete('/deletepost', [TeacherController::class, 'deletepost']);
Route::patch('/editpost', [TeacherController::class, 'editpost']);

Route::post('/newcomment', [TeacherController::class, 'newcomment']);
Route::delete('/deletecomment', [TeacherController::class, 'deletecomment']);
Route::patch('/editcomment', [TeacherController::class, 'editcomment']);

Route::post('/updateSubmitList', [TeacherController::class, 'updateSubmitList']);


//File
Route::post('/file_upload', [FileController::class, 'file_upload']);
Route::get('/getFile', [FileController::class, 'getFile']);


Route::post('/file_uploadTeacher', [FileController::class, 'file_uploadTeacher']);
Route::get('/getFileTeacher', [FileController::class, 'getFileTeacher']);
Route::get('/getFileTeacher2', [FileController::class, 'getFileTeacher2']);


Route::post('/file_uploadTask', [FileController::class, 'file_uploadTask']);
Route::get('/getFileTask', [FileController::class, 'getFileTask']);


Route::post('/submitTask', [FileController::class, 'submitTask']);

