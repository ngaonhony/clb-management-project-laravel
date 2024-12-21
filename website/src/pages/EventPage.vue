<template>
  <div class="min-h-screen bg-gray-50">
    <main class="max-w-7xl mx-auto px-4 py-8">
      <div class="bg-white rounded-lg shadow-lg overflow-hidden">
        <div class="p-8">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="md:col-span-2 space-y-6">
              <section>
                <h2 class="text-2xl font-bold mb-4">
                  Workshop "Data-driven Marketing"
                </h2>
                <div class="flex items-center space-x-4">
                  <img
                    src="https://example.com/logo.png"
                    alt="Marketing UEL Club Logo"
                    class="h-16 w-16 rounded-full object-cover" />
                  <div>
                    <h3 class="text-lg font-semibold">Marketing UEL Club</h3>
                    <p class="text-gray-600">Đơn vị tổ chức</p>
                  </div>
                </div>
              </section>
              <section>
                <h2 class="text-2xl font-bold mb-4">Nội dung chi tiết</h2>
                <div class="prose max-w-none">
                  <p>Kính gửi Quý Công ty,</p>
                  <p>
                    Lời đầu tiên, Marketing UEL Club xin gửi đến Quý Doanh
                    nghiệp lời chúc sức khỏe và lời chào trân trọng nhất.
                    Marketing UEL Club là câu lạc bộ học thuật chuyên về lĩnh
                    vực Marketing, trực thuộc Đoàn Khoa Quản trị Kinh doanh
                    Trường Đại học Kinh tế - Luật, Đại học Quốc gia Thành phố Hồ
                    Chí Minh.
                  </p>
                  <p>
                    Trong môi trường số hóa hiện nay, mọi lĩnh vực đều cần sử
                    dụng nguồn dữ liệu khổng lồ, bởi hiểu biết và khai thác hiệu
                    quả các chỉ số có thể định hình và thúc đẩy thành công của
                    mọi chiến dịch...
                  </p>
                </div>
              </section>
            </div>

            <div class="space-y-6">
              <div class="relative h-80">
                <img
                  src="https://example.com/workshop-banner.jpg"
                  alt="Data-driven Marketing Workshop Banner"
                  class="w-full h-full object-cover" />
                <div
                  class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                  <div class="text-center text-white">
                    <h1 class="text-4xl font-bold mb-4">
                      Workshop "Data-driven Marketing"
                    </h1>
                    <p class="text-xl">Marketing UEL Club</p>
                  </div>
                </div>
              </div>

              <div class="bg-gray-50 p-6 rounded-lg space-y-4">
                <h3 class="text-lg font-semibold mb-4">Thông tin workshop</h3>
                <div class="space-y-2">
                  <div class="flex items-start space-x-3">
                    <ClockIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Ngày bắt đầu</h4>
                      <p class="text-gray-600">Chủ nhật • 29/12/2024</p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <ClockIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Ngày kết thúc</h4>
                      <p class="text-gray-600">Chủ nhật • 29/12/2024</p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <MapPinIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Địa điểm</h4>
                      <p class="text-gray-600">Trường Đại học Kinh tế - Luật</p>
                      <p class="text-gray-600">Số 669, Quốc lộ 1A, Phường Linh Xuân, Thủ Đức, Thành phố Hồ Chí Minh</p>
                      <a href="#" class="text-blue-600 hover:text-blue-700 text-sm mt-1 inline-block">Xem bản đồ</a>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <UsersIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <p class="text-gray-600">1 người sẽ tham gia sự kiện này</p>
                    </div>
                  </div>
                </div>

                <button
                  class="w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition-colors">
                  Đăng ký
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { MapPinIcon, PhoneIcon, MailIcon, ClockIcon, UsersIcon } from "lucide-vue-next";
</script>

<style>
.prose {
  @apply text-gray-600 leading-relaxed;
}
.prose p {
  @apply mb-4;
}
img {
  object-fit: cover; /* Ensures images cover their containers */
}
</style>