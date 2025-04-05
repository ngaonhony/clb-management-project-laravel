<?php

namespace App\Providers;

// use DB;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\ServiceProvider;

// use function Psy\info;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        DB::listen(function ($query) {
            info($query->sql, $query->bindings, $query->time);
        });
    }
}
