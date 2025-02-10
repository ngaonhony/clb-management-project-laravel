<!DOCTYPE html>
<html>
<head>
    <title>Reset Your Password</title>
</head>
<body>
    <h1>Reset Your Password</h1>
    <p>Please use the following link to reset your password: <a href="{{ url('password/reset', $user->resetPasswordToken) }}">Reset Password</a></p>
</body>
</html> 