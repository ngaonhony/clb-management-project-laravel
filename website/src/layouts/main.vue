<template>
    <div id="app" class="flex flex-col h-screen">

        <!-- Main Content -->
        <div class="flex-1 flex flex-col">
            <Header />
            <div class="flex-1 overflow-y-auto">
                <router-view />
            </div>
        </div>

        <!-- Footer -->
        <Footer />
    </div>
</template>

<script>
import Header from "../components/Header.vue";
import Footer from "../components/Footer.vue";
import Menu from "../components/Menu.vue";

export default {
    components: {
        Header,
        Footer,
        Menu
    },
};
</script>