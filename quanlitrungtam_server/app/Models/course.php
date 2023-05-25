<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class course extends Model
{
    use HasFactory;

    protected $table='courses';
    protected $primaryKey='course_id';

    public function language(){
        return $this->belongsTo(language::class, 'language_id', 'language_id');
    }

    public function room(){
        return $this->hasMany(room::class, 'course_id', 'course_id');
    }



}