<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class document extends Model
{
    use HasFactory;

    protected $table='documents';
    protected $primaryKey='document_id';

    public function post(){
        return $this->belongsTo(post::class, 'post_id', 'post_id');
    }

}
