#include <stdio.h>
#include <unistd.h>
#include <seccomp.h>
#include <stdlib.h>
#include <sys/prctl.h>

int main() {
    // 1. Khởi tạo ngữ cảnh bộ lọc 
    // Nếu vi phạm, Kernel sẽ "giết" tiến trình ngay lập tức bằng luồng Trap cưỡng bức
    scmp_filter_ctx ctx;
    ctx = seccomp_init(SCMP_ACT_KILL);

    // 2. Thiết lập Danh sách trắng (Whitelist)
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);      // Để in kết quả
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit), 0);       
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit_group), 0); 
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(fstat), 0);      // Cần cho printf hoạt động

    // 3. Kích hoạt bộ lọc
    printf("--- Bộ lọc đang nạp vào Kernel... ---\n");
    if (seccomp_load(ctx) < 0) {
        perror("Lỗi nạp Seccomp");
        return 1;
    }
    printf("--- Bộ lọc đã hoạt động. Thử nghiệm luồng Trap... ---\n");

    // Thử nghiệm 1: Lệnh hợp lệ
    printf("Hành động hợp lệ: Đang gọi syscall 'write'...\n");

    // Thử nghiệm 2: Lệnh bị cấm để kích hoạt luồng bẫy (Trap)
    // 'getpid' không có trong Whitelist. 
    // Khi gọi, CPU chuyển sang Supervisor Mode (Trap), Kernel phát hiện vi phạm và chặn đứng.
    printf("Hành động vi phạm: Đang thử gọi 'getpid' để kích hoạt Trap...\n");
    int pid = getpid();

    // Dòng này sẽ KHÔNG bao giờ được in ra
    printf("Lỗi: Bạn đã vượt qua được bộ lọc! PID: %d\n", pid);

    seccomp_release(ctx);
    return 0;
}
