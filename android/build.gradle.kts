import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    tasks.withType<KotlinCompile>().configureEach {
        val javaVersion = project.extensions.findByName("android")?.let { android ->
            try {
                val co = android.javaClass.getMethod("getCompileOptions").invoke(android)
                co.javaClass.getMethod("getSourceCompatibility").invoke(co).toString()
            } catch (e: Exception) {
                null
            }
        }
        if (javaVersion != null) {
            if (javaVersion.contains("17")) {
                compilerOptions.jvmTarget.set(JvmTarget.JVM_17)
            } else if (javaVersion.contains("11")) {
                compilerOptions.jvmTarget.set(JvmTarget.JVM_11)
            } else {
                compilerOptions.jvmTarget.set(JvmTarget.JVM_1_8)
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
