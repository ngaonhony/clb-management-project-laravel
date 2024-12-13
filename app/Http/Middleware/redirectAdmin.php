<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class redirectAdmin
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next,$guard = null ):Response
    {
        if (Auth::guard($guard)->check() && Auth::user()->isAdmin == 1) {
            return redirect()->route('admin.dashboard');   
        }
        return $next($request);
    }
}
