package ute.edu;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class ASMWEBUTEApplication extends SpringBootServletInitializer {
	/** Cho phép chạy WAR trên servlet container, bên cạnh cách chạy trực tiếp bằng main. */
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(ASMWEBUTEApplication.class);
	}
	public static void main(String[] args) {
		SpringApplication.run(ASMWEBUTEApplication.class, args);
	}
}
