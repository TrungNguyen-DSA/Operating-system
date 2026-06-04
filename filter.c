#include <stdio.h>
#include <unistd.h>
#include <seccomp.h>
#include <sys/fcntl.h>
#include <stdlib.h>

int main() {
    // 1. Khởi tạo ngữ cảnh bộ lọc
    // SCMP_ACT_KILL: Mặc định sẽ tiêu diệt tiến trình nếu gọi syscall không có trong danh sách (Default Deny)
    scmp_filter_ctx ctx;
    ctx = seccomp_init(SCMP_ACT_KILL);

    // 2. Thiết lập Danh sách trắng (Whitelist) - Chỉ cho phép các syscall thiết yếu
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(read), 0);       // Đọc dữ liệu
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);      // Ghi dữ liệu/Xuất màn hình
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit), 0);       // Thoát tiến trình
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit_group), 0); // Thoát nhóm tiến trình
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(sigreturn), 0);  // Phục hồi sau tín hiệu
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(fstat), 0);      // Kiểm tra trạng thái file (printf cần)

    // 3. Nạp bộ lọc vào Nhân (Kernel)
    printf("--- Bo loc System Call da duoc kich hoat ---\n");
    seccomp_load(ctx);

    // --- KHÔNG GIAN THỬ NGHIỆM (UNIT TEST) ---
    // Trường hợp 1: syscall hợp lệ (write) -> Sẽ chạy bình thường vì nằm trong Whitelist
    write(STDOUT_FILENO, "Ket qua: Goi lenh write hop le thanh cong!\n", 43);

    // Trường hợp 2: syscall vi phạm (execve - gọi thông qua execl để chạy lệnh 'ls')
    // Lệnh này không có trong danh sách whitelist -> Sẽ bị Kernel chặn và giết tiến trình
    printf("Dang thu thuc hien hanh dong bi cam (execl)... \n");
    execl("/bin/ls", "ls", NULL);

    // Dòng này sẽ KHÔNG bao giờ được in ra nếu bộ lọc hoạt động đúng
    printf("Loi: Bo loc da bi qua mat!\n");
    
    // Giải phóng ngữ cảnh seccomp
    seccomp_release(ctx);
    return 0;
}
