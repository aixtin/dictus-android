package dev.pivisolutions.dictus.model

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Tests for the tolerant RAM threshold (issue #121), with totalMem readings in the
 * range real phones report: the OS sees less than the marketed size.
 */
class DeviceRamTest {

    private val parakeet = ModelCatalog.findByKey("parakeet-tdt-0.6b-v3")!!
    private val tiny = ModelCatalog.findByKey("tiny")!!

    private fun gib(value: Double): Long = (value * 1024 * 1024 * 1024).toLong()

    @Test
    fun `marketedGb rounds totalMem up to the marketed tier`() {
        assertEquals(6, DeviceRam.marketedGb(gib(5.5)))
        assertEquals(8, DeviceRam.marketedGb(gib(7.4)))
        assertEquals(8, DeviceRam.marketedGb(gib(7.9)))
        assertEquals(8, DeviceRam.marketedGb(gib(8.0)))
        assertEquals(12, DeviceRam.marketedGb(gib(11.6)))
    }

    @Test
    fun `8 GB phones reporting 7_4 and 7_9 GiB meet the 8 GB requirement`() {
        assertTrue(DeviceRam.meetsRequirement(parakeet, gib(7.4)))
        assertTrue(DeviceRam.meetsRequirement(parakeet, gib(7.9)))
    }

    @Test
    fun `8_0 and 11_6 GiB meet the 8 GB requirement`() {
        assertTrue(DeviceRam.meetsRequirement(parakeet, gib(8.0)))
        assertTrue(DeviceRam.meetsRequirement(parakeet, gib(11.6)))
    }

    @Test
    fun `6 GB phone reporting 5_5 GiB does not meet the 8 GB requirement`() {
        assertFalse(DeviceRam.meetsRequirement(parakeet, gib(5.5)))
    }

    @Test
    fun `models without a requirement are always runnable`() {
        assertTrue(DeviceRam.meetsRequirement(tiny, 0L))
    }

    @Test
    fun `onboarding recommends Parakeet on an 8 GB phone and small-q5_1 below`() {
        assertEquals("parakeet-tdt-0.6b-v3", ModelCatalog.recommendedModelKey(gib(7.4)))
        assertEquals("parakeet-tdt-0.6b-v3", ModelCatalog.recommendedModelKey(gib(11.6)))
        assertEquals("small-q5_1", ModelCatalog.recommendedModelKey(gib(5.5)))
    }
}
