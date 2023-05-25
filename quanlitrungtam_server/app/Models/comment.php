<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class comment extends Model
{
    use HasFactory;

    protected $table='comments';
    protected $primaryKey='comment_id';

    public function post(){
        return $this->belongsTo(post::class, 'post_id', 'post_id');
    }

    public function user_account(){
        return $this->belongsTo(user_account::class, 'account_id', 'account_id');
    }
}
