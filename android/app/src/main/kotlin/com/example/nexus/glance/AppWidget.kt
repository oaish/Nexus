package com.example.nexus.glance

import androidx.compose.runtime.Composable
import androidx.glance.GlanceAppWidget
import androidx.glance.GlanceId
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.GlanceModifier
import androidx.glance.text.Text
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

class AppWidget : GlanceAppWidget() {

    override val stateDefinition: GlanceStateDefinition<*>?
        get() = HomeWidgetGlanceStateDefinition() // Enables home_widget updates

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }

    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val prefs = currentState.preferences
        val counter = prefs.getInt("counter", 0)
        Box(
            modifier = GlanceModifier
                .background(Color.White)
                .padding(16.dp)
        ) {
            Column {
                Text(counter.toString())
            }
        }
    }
}
